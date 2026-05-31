--!optimize 2
-- Momentum SaveInstancer
-- Watches client-visible instances, snapshots new assets, and injects recovered
-- missing assets into ServerStorage during the final save.

local DEFAULT_SAVEINSTANCE_URL = "https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/saveinstance.luau"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local GLOBAL_ENV = getgenv and getgenv() or _G

local Momentum = {}
Momentum.Version = "0.5.0"

local state = {
	running = false,
	initialSaving = false,
	finalSaving = false,
	startedAt = 0,
	options = {},
	saveinstance = nil,
	connections = {},
	captured = {},
	order = {},
	logs = {},
	gui = nil,
	recoveredCount = 0,
	skippedCount = 0,
	capturedCount = 0,
	pending = {},
	lastOutputMode = "minimal",
}

local WRAPPER_KEYS = {
	AutoGui = true,
	CaptureDelay = true,
	CompactFinalSave = true,
	FastCaptureDelay = true,
	FinalFilePath = true,
	GroupRecoveredByParent = true,
	IgnorePlayerCharacters = true,
	IncludeLiveCaptured = true,
	InitialFilePath = true,
	MaxCapturedRoots = true,
	MaxSnapshotDescendants = true,
	OutputMode = true,
	RecoveredFolderName = true,
	RefreshAncestorSnapshots = true,
	RunInitialSave = true,
	SaveInstance = true,
	SaveInstanceUrl = true,
	SaveOptions = true,
	SnapshotCooldown = true,
}

local function shallowCopy(source)
	local result = {}
	if type(source) == "table" then
		for key, value in source do
			result[key] = value
		end
	end
	return result
end

local function mergeOptions(...)
	local result = {}
	for i = 1, select("#", ...) do
		local source = select(i, ...)
		if type(source) == "table" then
			for key, value in source do
				result[key] = value
			end
		end
	end
	return result
end

local function log(message)
	local text = "[" .. os.date("%H:%M:%S") .. "] " .. tostring(message)
	table.insert(state.logs, 1, text)
	while #state.logs > 30 do
		table.remove(state.logs)
	end
	print("[Momentum SaveInstancer] " .. tostring(message))
end

local function safeDestroy(instance)
	if instance then
		pcall(function()
			instance:Destroy()
		end)
	end
end

local function safeSetAttribute(instance, name, value)
	pcall(function()
		instance:SetAttribute(name, value)
	end)
end

local function safeClearAttributes(instance)
	pcall(function()
		for name in pairs(instance:GetAttributes()) do
			instance:SetAttribute(name, nil)
		end
	end)
end

local function safeFullName(instance)
	local ok, result = pcall(function()
		return instance:GetFullName()
	end)
	if ok then
		return result
	end
	return tostring(instance)
end

local function sanitizeName(value)
	value = tostring(value or "Unknown")
	value = string.gsub(value, "[%c<>:\"/\\|?*]", "_")
	value = string.gsub(value, "%s+", " ")
	if value == "" then
		value = "Unknown"
	end
	return string.sub(value, 1, 80)
end

local function getGuiParent()
	local gethui = GLOBAL_ENV.gethui
	if type(gethui) == "function" then
		local ok, result = pcall(gethui)
		if ok and result then
			return result
		end
	end
	return CoreGui
end

local function protectGui(gui)
	local protectgui = GLOBAL_ENV.protectgui or syn and syn.protect_gui
	if type(protectgui) == "function" then
		pcall(protectgui, gui)
	end
end

local function addConnection(connection)
	table.insert(state.connections, connection)
	return connection
end

local function clearConnections()
	for _, connection in state.connections do
		pcall(function()
			connection:Disconnect()
		end)
	end
	table.clear(state.connections)
end

local function isLive(instance)
	local ok, result = pcall(function()
		return instance:IsDescendantOf(game)
	end)
	return ok and result
end

local function getOptionNumber(name, fallback, minimum)
	local value = state.options[name]
	if type(value) ~= "number" then
		return fallback
	end
	if minimum and value < minimum then
		return fallback
	end
	return value
end

local function normalizeOutputMode(value)
	value = string.lower(tostring(value or "minimal"))
	if value == "full" or value == "full_place" or value == "fullgame" then
		return "full"
	elseif value == "model" or value == "rbxmx" then
		return "model"
	end
	return "minimal"
end

local function safeIsA(instance, className)
	local ok, result = pcall(function()
		return instance:IsA(className)
	end)
	return ok and result
end

local function isAssetRootCandidate(instance)
	if typeof(instance) ~= "Instance" then
		return false
	end
	return safeIsA(instance, "Model")
		or safeIsA(instance, "Folder")
		or safeIsA(instance, "Tool")
		or safeIsA(instance, "Accessory")
		or safeIsA(instance, "BasePart")
		or safeIsA(instance, "LayerCollector")
		or safeIsA(instance, "GuiObject")
		or safeIsA(instance, "Sound")
		or safeIsA(instance, "Decal")
		or safeIsA(instance, "Texture")
		or safeIsA(instance, "ParticleEmitter")
		or safeIsA(instance, "Trail")
		or safeIsA(instance, "Beam")
		or safeIsA(instance, "Light")
		or safeIsA(instance, "Constraint")
		or safeIsA(instance, "Animation")
		or safeIsA(instance, "DataModelMesh")
end

local function countDescendantsLimited(instance, limit)
	local total = 0
	local function visit(parent)
		local ok, children = pcall(function()
			return parent:GetChildren()
		end)
		if not ok then
			return false
		end
		for _, child in children do
			total += 1
			if limit < total then
				return false
			end
			if not visit(child) then
				return false
			end
		end
		return true
	end
	visit(instance)
	return total
end

local function hasPendingAncestor(instance)
	local parent = instance.Parent
	while parent and parent ~= game do
		if state.pending[parent] then
			return true
		end
		parent = parent.Parent
	end
	return false
end

local function clearPendingDescendants(instance)
	for pendingInstance in state.pending do
		local ok, result = pcall(function()
			return pendingInstance:IsDescendantOf(instance)
		end)
		if ok and result and pendingInstance ~= instance then
			state.pending[pendingInstance] = nil
		end
	end
end

local function isPlayerCharacterDescendant(instance)
	for _, player in Players:GetPlayers() do
		local character = player.Character
		if character then
			local ok, result = pcall(function()
				return instance == character or instance:IsDescendantOf(character)
			end)
			if ok and result then
				return true
			end
		end
	end
	return false
end

local function isIgnored(instance)
	if typeof(instance) ~= "Instance" or instance == game then
		return true
	end
	if state.gui then
		local ok, result = pcall(function()
			return instance == state.gui or instance:IsDescendantOf(state.gui)
		end)
		if ok and result then
			return true
		end
	end
	do
		local ok, result = pcall(function()
			return instance:IsDescendantOf(CoreGui)
		end)
		if ok and result then
			return true
		end
	end
	if state.options.IgnorePlayerCharacters ~= false and isPlayerCharacterDescendant(instance) then
		return true
	end
	local ignoreList = state.options.IgnoreList
	if type(ignoreList) == "table" then
		for _, ignored in ignoreList do
			if typeof(ignored) == "Instance" then
				local ok, result = pcall(function()
					return instance == ignored or instance:IsDescendantOf(ignored)
				end)
				if ok and result then
					return true
				end
			elseif type(ignored) == "string" and instance.ClassName == ignored then
				return true
			end
		end
	end
	return false
end

local function buildAncestorSet(instance)
	local ancestors = {}
	local parent = instance.Parent
	while parent and parent ~= game do
		ancestors[parent] = true
		parent = parent.Parent
	end
	return ancestors
end

local function getParentFullName(instance)
	local parent = instance.Parent
	if parent and parent ~= game then
		return safeFullName(parent)
	end
	return "game"
end

local function cloneSnapshot(instance)
	local oldArchivable
	pcall(function()
		oldArchivable = instance.Archivable
		instance.Archivable = true
	end)

	local ok, clone = pcall(function()
		return instance:Clone()
	end)

	if oldArchivable ~= nil then
		pcall(function()
			instance.Archivable = oldArchivable
		end)
	end

	if not ok or not clone then
		return nil
	end

	return clone
end

local function compactSnapshot(instance)
	if state.options.CompactFinalSave == false then
		return
	end

	local function compactOne(target, keepAttributes)
		if not keepAttributes then
			safeClearAttributes(target)
		end
		if safeIsA(target, "LuaSourceContainer") then
			pcall(function()
				target.Disabled = true
			end)
		elseif safeIsA(target, "BasePart") then
			pcall(function()
				target.Anchored = true
				target.CanTouch = false
				target.CanQuery = false
			end)
		end
	end

	compactOne(instance, true)
	for _, descendant in instance:GetDescendants() do
		compactOne(descendant)
	end
end

local function updateSnapshot(instance, reason)
	if isIgnored(instance) then
		return
	end

	local record = state.captured[instance]
	local now = os.clock()
	local cooldown = getOptionNumber("SnapshotCooldown", 1, 0)
	if reason ~= "settled" and record and record.lastSeen and now - record.lastSeen < cooldown then
		return
	end

	local maxRoots = getOptionNumber("MaxCapturedRoots", 2500, 1)
	if not record and maxRoots <= #state.order then
		state.skippedCount += 1
		log("Skipped capture: root limit reached (" .. tostring(maxRoots) .. ")")
		return
	end

	local maxDescendants = getOptionNumber("MaxSnapshotDescendants", 4000, 1)
	local descendantCount = countDescendantsLimited(instance, maxDescendants)
	if maxDescendants < descendantCount then
		state.skippedCount += 1
		log("Skipped huge " .. instance.ClassName .. " at " .. safeFullName(instance))
		return
	end

	local clone = cloneSnapshot(instance)
	if not clone then
		state.skippedCount += 1
		return
	end

	if not record then
		record = {
			original = instance,
			className = instance.ClassName,
			firstSeen = now,
			fullName = safeFullName(instance),
			parentFullName = getParentFullName(instance),
			ancestors = buildAncestorSet(instance),
		}
		state.captured[instance] = record
		table.insert(state.order, record)
		state.capturedCount = #state.order
	end

	safeDestroy(record.snapshot)
	record.snapshot = clone
	record.lastSeen = now
	record.reason = reason or "updated"
	record.fullName = record.fullName or safeFullName(instance)
	record.parentFullName = getParentFullName(instance)
	record.ancestors = buildAncestorSet(instance)
	record.descendantCount = descendantCount

	safeSetAttribute(clone, "MomentumOriginalPath", record.fullName)
	safeSetAttribute(clone, "MomentumOriginalParentPath", record.parentFullName)
	safeSetAttribute(clone, "MomentumOriginalClassName", record.className)
	safeSetAttribute(clone, "MomentumCapturedAt", record.firstSeen)
	safeSetAttribute(clone, "MomentumLastSeenAt", record.lastSeen)
	safeSetAttribute(clone, "MomentumDescendantCount", descendantCount)

	if reason ~= "ancestor-refresh" then
		local count = #state.order
		if count <= 20 or count % 50 == 0 or reason == "settled" and count <= 25 then
			log("Captured " .. tostring(count) .. ": " .. record.className .. " at " .. record.fullName)
		end
	end
end

local function refreshCapturedAncestors(instance)
	if state.options.RefreshAncestorSnapshots == false then
		return
	end

	local parent = instance.Parent
	while parent and parent ~= game do
		if state.captured[parent] and isLive(parent) then
			updateSnapshot(parent, "ancestor-refresh")
		end
		parent = parent.Parent
	end
end

local function captureAdded(instance)
	if not state.running then
		return
	end
	if isIgnored(instance) then
		return
	end
	if hasPendingAncestor(instance) and not isAssetRootCandidate(instance) then
		return
	end

	state.pending[instance] = true
	clearPendingDescendants(instance)

	local function fastCapture()
		if state.running and state.pending[instance] and isLive(instance) then
			updateSnapshot(instance, "fast")
			Momentum.UpdateGui()
		end
	end

	local fastDelay = getOptionNumber("FastCaptureDelay", 0, 0)
	if fastDelay == 0 then
		fastCapture()
	else
		task.delay(fastDelay, fastCapture)
	end

	task.delay(getOptionNumber("CaptureDelay", 0.75, 0), function()
		if not state.running or not state.pending[instance] then
			return
		end
		state.pending[instance] = nil
		if isLive(instance) then
			updateSnapshot(instance, "settled")
			refreshCapturedAncestors(instance)
			Momentum.UpdateGui()
		end
	end)
end

local function loadSaveInstance(options)
	if type(options.SaveInstance) == "function" then
		return options.SaveInstance
	end
	if type(state.saveinstance) == "function" then
		return state.saveinstance
	end
	if type(GLOBAL_ENV.MomentumSaveInstancer_SaveInstance) == "function" then
		return GLOBAL_ENV.MomentumSaveInstancer_SaveInstance
	end
	if type(GLOBAL_ENV.saveinstance) == "function" then
		return GLOBAL_ENV.saveinstance
	end

	local url = options.SaveInstanceUrl or DEFAULT_SAVEINSTANCE_URL
	local source = game:HttpGet(url, true)
	local loaded, err = loadstring(source, "saveinstance")
	assert(loaded, err)
	local saveinstance = loaded()
	state.saveinstance = saveinstance
	return saveinstance
end

local function buildSaveOptions(phase, extra)
	local wrapperOptions = state.options
	local base = wrapperOptions.SaveOptions and shallowCopy(wrapperOptions.SaveOptions) or shallowCopy(wrapperOptions)
	for key in WRAPPER_KEYS do
		base[key] = nil
	end

	base.ReadMe = base.ReadMe ~= false
	base.ShowStatus = base.ShowStatus ~= false
	base.RemovePlayerCharacters = base.RemovePlayerCharacters ~= false
	base.FilePath = phase == "initial"
		and (wrapperOptions.InitialFilePath or base.InitialFilePath or ("momentum_initial_" .. tostring(game.PlaceId)))
		or (wrapperOptions.FinalFilePath or base.FinalFilePath or ("momentum_final_" .. tostring(game.PlaceId)))

	return mergeOptions(base, extra)
end

local function buildFinalSaveOptions(recoveredFolder)
	local outputMode = normalizeOutputMode(state.options.OutputMode)
	state.lastOutputMode = outputMode

	if outputMode == "model" then
		recoveredFolder.Name = state.options.RecoveredFolderName or "MomentumRecoveredAssets"
		return buildSaveOptions("final", {
			Object = recoveredFolder,
			IsModel = true,
			mode = "full",
			ReadMe = false,
			noscripts = true,
		})
	end

	local serverStorage = game:GetService("ServerStorage")
	local extra = {
		VirtualChildren = {
			[serverStorage] = { recoveredFolder },
		},
		ReadMe = false,
		noscripts = true,
	}

	if outputMode == "minimal" then
		extra.mode = "invalid"
		extra.ExtraInstances = { serverStorage }
		extra.IsModel = false
	end

	return buildSaveOptions("final", extra)
end

local function shouldSkipNestedRecord(record, includeLiveCaptured)
	for ancestor in record.ancestors do
		local ancestorRecord = state.captured[ancestor]
		if
			ancestorRecord
			and ancestorRecord.snapshot
			and (includeLiveCaptured or not isLive(ancestor))
			and (ancestorRecord.lastSeen or 0) >= (record.firstSeen or 0)
		then
			return true
		end
	end
	return false
end

local function clearSnapshots()
	for _, record in state.order do
		if record.snapshot then
			safeDestroy(record.snapshot)
			record.snapshot = nil
		end
	end
end

local function buildRecoveredFolder()
	local folder = Instance.new("Folder")
	folder.Name = state.options.RecoveredFolderName or "MomentumRecoveredAssets"
	safeSetAttribute(folder, "MomentumGenerated", true)
	safeSetAttribute(folder, "MomentumStartedAt", state.startedAt)
	safeSetAttribute(folder, "MomentumStoppedAt", os.clock())

	local recovered = 0
	local includeLiveCaptured = state.options.IncludeLiveCaptured ~= false
	local groupByParent = state.options.GroupRecoveredByParent ~= false
	local groups = {}
	local function getGroup(record)
		if not groupByParent then
			return folder
		end
		local key = record.parentFullName or "game"
		local group = groups[key]
		if not group then
			group = Instance.new("Folder")
			group.Name = sanitizeName(key)
			safeSetAttribute(group, "MomentumOriginalParentPath", key)
			group.Parent = folder
			groups[key] = group
		end
		return group
	end

	for _, record in state.order do
		local shouldRecover = record.snapshot
			and (includeLiveCaptured or not isLive(record.original))
			and not shouldSkipNestedRecord(record, includeLiveCaptured)
		if shouldRecover then
			local clone = record.snapshot
			record.snapshot = nil
			compactSnapshot(clone)
			pcall(function()
				clone.Parent = getGroup(record)
			end)
			recovered += 1
		end
	end

	state.recoveredCount = recovered
	return folder, recovered
end

local function runInitialSave()
	state.initialSaving = true
	Momentum.UpdateGui()
	log("Running initial save")

	local ok, err = xpcall(function()
		state.saveinstance(buildSaveOptions("initial"))
	end, debug.traceback)

	state.initialSaving = false
	if ok then
		log("Initial save finished")
	else
		warn("[Momentum SaveInstancer] Initial save failed:")
		warn(err)
		log("Initial save failed; check F9 console")
	end
	Momentum.UpdateGui()
end

local function runFinalSave()
	while state.initialSaving do
		task.wait(0.25)
	end

	state.finalSaving = true
	Momentum.UpdateGui()

	local recoveredFolder, recovered = buildRecoveredFolder()
	log("Recovered " .. recovered .. " missing captured root(s)")

	local options = buildFinalSaveOptions(recoveredFolder)
	log("Writing " .. state.lastOutputMode .. " output")

	local ok, err = xpcall(function()
		state.saveinstance(options)
	end, debug.traceback)

	state.finalSaving = false
	if ok then
		log("Final save finished")
	else
		warn("[Momentum SaveInstancer] Final save failed:")
		warn(err)
		log("Final save failed; check F9 console")
	end

	safeDestroy(recoveredFolder)
	clearSnapshots()
	state.capturedCount = #state.order
	table.clear(state.captured)
	table.clear(state.order)
	table.clear(state.pending)
	Momentum.UpdateGui()
end

function Momentum.Start(options)
	if state.running then
		log("Already running")
		return false
	end

	options = mergeOptions({
		CaptureDelay = 0.75,
		CompactFinalSave = true,
		FastCaptureDelay = 0,
		GroupRecoveredByParent = true,
		IgnorePlayerCharacters = true,
		IncludeLiveCaptured = true,
		MaxCapturedRoots = 2500,
		MaxSnapshotDescendants = 4000,
		OutputMode = "minimal",
		RefreshAncestorSnapshots = false,
		RunInitialSave = false,
		SnapshotCooldown = 1,
	}, options or {})

	state.options = options
	state.running = true
	state.startedAt = os.clock()
	state.recoveredCount = 0
	state.skippedCount = 0
	state.capturedCount = 0
	state.lastOutputMode = normalizeOutputMode(options.OutputMode)
	table.clear(state.captured)
	table.clear(state.order)
	table.clear(state.logs)
	table.clear(state.pending)

	local ok, result = xpcall(function()
		return loadSaveInstance(options)
	end, debug.traceback)
	if not ok or type(result) ~= "function" then
		state.running = false
		warn("[Momentum SaveInstancer] Could not load saveinstance:")
		warn(result)
		log("Could not load saveinstance")
		Momentum.UpdateGui()
		return false
	end

	state.saveinstance = result
	clearConnections()
	addConnection(game.DescendantAdded:Connect(captureAdded))
	addConnection(Players.PlayerAdded:Connect(function(player)
		addConnection(player.CharacterAdded:Connect(function(character)
			task.defer(function()
				if state.options.IgnorePlayerCharacters ~= false then
					return
				end
				captureAdded(character)
			end)
		end))
	end))

	log("Watcher started")
	if options.RunInitialSave then
		task.spawn(runInitialSave)
	else
		log("Initial save skipped")
	end
	Momentum.UpdateGui()
	return true
end

function Momentum.Stop()
	if not state.running then
		log("Not running")
		return false
	end

	state.running = false
	clearConnections()
	table.clear(state.pending)
	log("Watcher stopped")
	task.spawn(runFinalSave)
	Momentum.UpdateGui()
	return true
end

function Momentum.IsRunning()
	return state.running
end

local function makeLabel(parent, text, position, size, textSize)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = text
	label.TextColor3 = Color3.fromRGB(232, 238, 242)
	label.TextSize = textSize or 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Position = position
	label.Size = size
	label.Parent = parent
	return label
end

local function makeButton(parent, text, position, size, color)
	local button = Instance.new("TextButton")
	button.AutoButtonColor = true
	button.BackgroundColor3 = color
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamBold
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	button.Position = position
	button.Size = size
	button.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button
	return button
end

local function makeToggle(parent, text, position, initial)
	local button = makeButton(parent, "", position, UDim2.new(0, 170, 0, 28), Color3.fromRGB(45, 52, 61))
	local value = initial
	local function render()
		button.Text = (value and "[x] " or "[ ] ") .. text
		button.BackgroundColor3 = value and Color3.fromRGB(52, 99, 71) or Color3.fromRGB(45, 52, 61)
	end
	render()
	button.MouseButton1Click:Connect(function()
		value = not value
		render()
	end)
	return {
		Button = button,
		Get = function()
			return value
		end,
		Set = function(nextValue)
			value = nextValue
			render()
		end,
	}
end

local function makeTextbox(parent, text, position, size)
	local box = Instance.new("TextBox")
	box.BackgroundColor3 = Color3.fromRGB(31, 36, 43)
	box.BorderSizePixel = 0
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = text
	box.Text = text
	box.TextColor3 = Color3.fromRGB(235, 240, 244)
	box.PlaceholderColor3 = Color3.fromRGB(132, 143, 154)
	box.TextSize = 13
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Position = position
	box.Size = size
	box.Parent = parent
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = box
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = box
	return box
end

local function enableDrag(frame, handle)
	local dragging = false
	local dragStart
	local startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Momentum.CreateGui()
	if state.gui then
		state.gui:Destroy()
		state.gui = nil
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "MomentumSaveInstancer"
	gui.DisplayOrder = 2000000000
	gui.ResetOnSpawn = false
	protectGui(gui)
	local parented = pcall(function()
		gui.Parent = getGuiParent()
	end)
	if not parented then
		local localPlayer = Players.LocalPlayer
		local playerGui = localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")
		parented = pcall(function()
			gui.Parent = playerGui or CoreGui
		end)
	end
	if not parented then
		warn("[Momentum SaveInstancer] Could not parent GUI")
		return gui
	end
	state.gui = gui

	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.fromRGB(22, 26, 31)
	frame.BorderSizePixel = 0
	frame.Position = UDim2.new(0.5, -190, 0.5, -196)
	frame.Size = UDim2.new(0, 380, 0, 392)
	frame.Parent = gui
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 8)
	frameCorner.Parent = frame

	local header = Instance.new("Frame")
	header.BackgroundColor3 = Color3.fromRGB(34, 40, 48)
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, 42)
	header.Parent = frame
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local title = makeLabel(header, "Momentum SaveInstancer", UDim2.new(0, 14, 0, 0), UDim2.new(1, -60, 1, 0), 15)
	title.Font = Enum.Font.GothamBold

	local close = makeButton(header, "X", UDim2.new(1, -38, 0, 8), UDim2.new(0, 28, 0, 26), Color3.fromRGB(88, 44, 50))
	close.MouseButton1Click:Connect(function()
		gui.Enabled = false
	end)

	local status = makeLabel(frame, "Idle", UDim2.new(0, 14, 0, 52), UDim2.new(1, -28, 0, 22), 13)
	local stats = makeLabel(frame, "Captured: 0 | Recovered: 0", UDim2.new(0, 14, 0, 76), UDim2.new(1, -28, 0, 22), 13)

	makeLabel(frame, "Final filename", UDim2.new(0, 14, 0, 106), UDim2.new(0, 110, 0, 20), 12)
	local finalName = makeTextbox(frame, "momentum_final_" .. tostring(game.PlaceId), UDim2.new(0, 112, 0, 102), UDim2.new(1, -126, 0, 30))

	local readMeToggle = makeToggle(frame, "ReadMe", UDim2.new(0, 14, 0, 142), true)
	local characterToggle = makeToggle(frame, "Ignore Characters", UDim2.new(0, 196, 0, 142), true)
	local initialSaveToggle = makeToggle(frame, "Initial Save", UDim2.new(0, 14, 0, 176), false)
	local lightOutputToggle = makeToggle(frame, "Light RBXLX", UDim2.new(0, 196, 0, 176), true)
	local liveSeenToggle = makeToggle(frame, "Save Seen Live", UDim2.new(0, 14, 0, 208), true)

	local start = makeButton(frame, "Start", UDim2.new(0, 14, 0, 240), UDim2.new(0, 170, 0, 34), Color3.fromRGB(42, 126, 79))
	local stop = makeButton(frame, "Stop", UDim2.new(0, 196, 0, 240), UDim2.new(0, 170, 0, 34), Color3.fromRGB(132, 66, 61))

	local logTitle = makeLabel(frame, "Log", UDim2.new(0, 14, 0, 286), UDim2.new(1, -28, 0, 18), 12)
	logTitle.Font = Enum.Font.GothamBold
	local logFrame = Instance.new("Frame")
	logFrame.BackgroundColor3 = Color3.fromRGB(17, 20, 24)
	logFrame.BorderSizePixel = 0
	logFrame.Position = UDim2.new(0, 14, 0, 308)
	logFrame.Size = UDim2.new(1, -28, 0, 64)
	logFrame.Parent = frame
	local logCorner = Instance.new("UICorner")
	logCorner.CornerRadius = UDim.new(0, 6)
	logCorner.Parent = logFrame

	local logLabels = {}
	for i = 1, 4 do
		logLabels[i] = makeLabel(logFrame, "", UDim2.new(0, 8, 0, (i - 1) * 15 + 2), UDim2.new(1, -16, 0, 15), 11)
		logLabels[i].TextColor3 = Color3.fromRGB(172, 184, 194)
	end

	start.MouseButton1Click:Connect(function()
		Momentum.Start({
			FinalFilePath = finalName.Text ~= "" and finalName.Text or nil,
			IgnorePlayerCharacters = characterToggle.Get(),
			IncludeLiveCaptured = liveSeenToggle.Get(),
			OutputMode = lightOutputToggle.Get() and "minimal" or "full",
			RunInitialSave = initialSaveToggle.Get(),
			SaveOptions = {
				ReadMe = readMeToggle.Get(),
				ScriptSourceHeader = false,
				LinkedSourceComment = false,
				TreatUnionsAsParts = false,
				TreatUnreadableUnionsAsParts = false,
				IgnoreSpecialProperties = false,
				IgnoreSharedStrings = false,
			},
		})
	end)

	stop.MouseButton1Click:Connect(function()
		Momentum.Stop()
	end)

	state.guiControls = {
		status = status,
		stats = stats,
		logLabels = logLabels,
	}

	enableDrag(frame, header)
	Momentum.UpdateGui()
	return gui
end

function Momentum.UpdateGui()
	local controls = state.guiControls
	if not controls then
		return
	end

	local elapsed = state.startedAt ~= 0 and os.clock() - state.startedAt or 0
	local statusText = state.running and "Running"
		or state.finalSaving and "Writing final save"
		or state.initialSaving and "Writing initial save"
		or "Idle"
	controls.status.Text = string.format("%s | %.1fs", statusText, elapsed)
	controls.stats.Text = "Captured: "
		.. tostring(math.max(state.capturedCount, #state.order))
		.. " | Skipped: "
		.. tostring(state.skippedCount)
		.. " | Recovered: "
		.. tostring(state.recoveredCount)
		.. " | "
		.. state.lastOutputMode
	for i, label in controls.logLabels do
		label.Text = state.logs[i] or ""
	end
end

task.spawn(function()
	while true do
		task.wait(0.5)
		Momentum.UpdateGui()
	end
end)

GLOBAL_ENV.MomentumSaveInstancer = Momentum

if GLOBAL_ENV.MomentumSaveInstancer_NoAutoGui ~= true then
	task.defer(function()
		Momentum.CreateGui()
	end)
end

return Momentum
