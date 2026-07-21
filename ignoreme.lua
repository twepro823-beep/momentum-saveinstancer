--[[

____               _____           _       ___
/ __ \___  _  __   / ___/___  _____(_)___ _/ (_)___  ___  _____
/ / / / _ \| |/_/   \__ \/ _ \/ ___/ / __ `/ / /_  / / _ \/ ___/
/ /_/ /  __/>  <    ___/ /  __/ /  / / /_/ / / / / /_/  __/ /
/_____/\___/_/|_|   /____/\___/_/  /_/\__,_/_/_/ /___/\___/_/


The most accurate and top lua roblox binary format serializer since late 2020

Made in preparation for The Augur's reign that started in July 2021

Many ServerScriptService and ServerStorage models of top games were saved with top accuracy


This is old and discontinued, but the agency released it to show people the grand serializer that
powered the saveinstance function in the top executors at the time before they were discontinued:
- ScriptWare
- Synapse X

]]


-- Made by Moon
local Main,Serializer,API,Settings,DefaultSettings,env

local service = setmetatable({},{__index = function(self,name)
    local serv = game:GetService(name)
    self[name] = serv
    return serv
    end})

-- Helper functions for new features
local function activateSafeMode()
if pcall(function() game:GetService"Players".LocalPlayer:Kick("SaveInstance SafeMode: Saving initiated. Goodbye!") end) then
    wait(1)
    end
    end

    local function boostFPS()
    local success = false
    if pcall(function()
        local gameSettings = UserSettings():FindFirstChild("GameSettings")
        if gameSettings then
            gameSettings.FPSUnlocked = false
            gameSettings.MasterVolume = 0
            success = true
            end
            end) then
            -- Try disabling rendering via camera if available
            if workspace.CurrentCamera then
                workspace.CurrentCamera.MaxAxisOfRotation = 0
                end
                end
                return success
                end

                local function startAntiIdle()
                local antiIdleConn
                antiIdleConn = service.RunService.Heartbeat:Connect(function()
                -- Send periodic inputs to prevent idle timeout
                pcall(function()
                if game:FindFirstChild("__AntiIdleMouse") then return end
                    local mouse = game:FindFirstChild("__AntiIdleMouse") or game.Players.LocalPlayer:GetMouse()
                    if mouse then
                        local pos = mouse.Hit.Position
                        mouse.move(pos)
                        end
                        end)
                end)
                return antiIdleConn
                end

                local function cleanAnonymousData(root, options)
                if not options.Anonymous then return end
                    -- Placeholder: would scrub player name and userid from instances
                    -- This is a simplified version; full implementation would recursively check properties
                    end

                    DefaultSettings = {
                        Serializer = {
                            _Recurse = true,
                            -- Decompilation
                            Decompile = false,
                            DecompileTimeout = 10,
                            MaxThreads = 3,
                            DecompileIgnore = {"Chat","CoreGui","CorePackages"},
                            SaveScriptCache = false,
                            SaveBytecode = false,
                            -- Instance Selection
                            NilInstances = false,
                            RemovePlayerCharacters = true,
                            SavePlayers = false,
                            IsolateStarterPlayer = true,
                            IsolateLocalPlayer = false,
                            SavePlayerCharacters = false,
                            -- Property Filtering
                            IgnoreDefaultProps = true,
                            IgnoreNotArchivable = true,
                            -- Output & Formatting
                            Binary = true,
                        ShowStatus = true,
                        ReadMe = true,
                            Mode = "full",
                            FilePath = false,
                            Callback = false,
                            Clipboard = false,
                            AvoidFileOverwrite = true,
                            -- Safety Features
                            SafeMode = false,
                            BoostFPS = false,
                            KillAllScripts = false,
                            AntiIdle = false,
                            -- Data Cleanup
                            Anonymous = false
                        }
                    }

                    -- Compatibility shims for environments missing newer Lua helpers
                    do
                        if not table.clear then
                            table.clear = function(t)
                            for k in pairs(t) do t[k] = nil end
                                end
                                end

                                if not string.split then
                                    string.split = function(s, sep)
                                    sep = sep or "%s"
                                    local res = {}
                                    if sep == "%s" then
                                        for token in s:gmatch("%S+") do res[#res+1] = token end
                                            else
                                                local pattern = "(.-)" .. sep
                                                local last_end = 1
                                                local s_len = #s
                                                local init = 1
                                                while true do
                                                    local st, en, cap = s:find(pattern, init)
                                                    if not st then break end
                                                        res[#res+1] = cap
                                                        init = en + 1
                                                        end
                                                        if init <= s_len then
                                                            res[#res+1] = s:sub(init)
                                                            end
                                                            end
                                                            return res
                                                            end
                                                            end

                                                            if not table.move then
                                                                table.move = function(a, f, e, t, dest)
                                                                dest = dest or 1
                                                                for i = f, e do a[dest + (i - f)] = a[i] end
                                                                    return a
                                                                    end
                                                                    end
                                                                    end

                                                                    Serializer = (function()
                                                                    local Serializer = {}

                                                                    local oldIndex,getnspval,getbspval,gethiddenprop,getnilinstances,getpcd,encodeBase64,lz4compress,hashmd5
                                                                    local classes,saveProps,testInsts = {},{},{}
                                                                    local tostring = tostring
                                                                    local format = string.format
                                                                    local gsub = string.gsub
                                                                    local sub = string.sub
                                                                    local getChildren = game.GetChildren
                                                                    local isa = game.IsA
                                                                    local components = CFrame.new(0,0,0).GetComponents
                                                                    local httpService = service.HttpService
                                                                    local urlEncode = httpService.UrlEncode
                                                                    local concat = table.concat
                                                                    local lrotate = bit32.lrotate
                                                                    local tableCreate = table.create
                                                                    local select = select
                                                                    local unpack = unpack
                                                                    local split = string.split
                                                                    local s_rep = string.rep
                                                                    local nilSafe = {}
                                                                    local gameId

                                                                    local s_pack, s_unpack
                                                                    if rawget(_G, "buffer") then
                                                                        function s_pack(fmt, ...)
                                                                        local args = { ... }
                                                                        local buf = buffer.create(256)
                                                                        local offset, fmt_pos, arg_idx = 0, 1, 1
                                                                        while fmt_pos <= #fmt do
                                                                            local char = fmt:sub(fmt_pos, fmt_pos)
                                                                            if char == '<' or char == '>' or char == '=' then
                                                                                fmt_pos = fmt_pos + 1
                                                                                elseif char == 'I' then
                                                                                    fmt_pos = fmt_pos + 1
                                                                                    if fmt:sub(fmt_pos, fmt_pos) == '4' then
                                                                                        buffer.writeu32(buf, offset, args[arg_idx])
                                                                                        offset = offset + 4; arg_idx = arg_idx + 1; fmt_pos = fmt_pos + 1
                                                                                        end
                                                                                        elseif char == 'i' then
                                                                                            fmt_pos = fmt_pos + 1
                                                                                            if fmt:sub(fmt_pos, fmt_pos) == '4' then
                                                                                                buffer.writei32(buf, offset, args[arg_idx])
                                                                                                offset = offset + 4; arg_idx = arg_idx + 1; fmt_pos = fmt_pos + 1
                                                                                                end
                                                                                                elseif char == 'f' then
                                                                                                    buffer.writef32(buf, offset, args[arg_idx]); offset = offset + 4; arg_idx = arg_idx + 1; fmt_pos = fmt_pos + 1
                                                                                                    elseif char == 'd' then
                                                                                                        buffer.writef64(buf, offset, args[arg_idx]); offset = offset + 8; arg_idx = arg_idx + 1; fmt_pos = fmt_pos + 1
                                                                                                        elseif char == 'b' then
                                                                                                            buffer.writei8(buf, offset, args[arg_idx] or 0); offset = offset + 1; arg_idx = arg_idx + 1; fmt_pos = fmt_pos + 1
                                                                                                            elseif char == 'B' then
                                                                                                                buffer.writeu8(buf, offset, args[arg_idx] or 0); offset = offset + 1; arg_idx = arg_idx + 1; fmt_pos = fmt_pos + 1
                                                                                                                else
                                                                                                                    fmt_pos = fmt_pos + 1
                                                                                                                    end
                                                                                                                    end
                                                                                                                    return buffer.readstring(buf, 0, offset)
                                                                                                                    end

                                                                                                                    function s_unpack(fmt, data, offset)
                                                                                                                    offset = offset or 1
                                                                                                                    local buf_offset = offset - 1
                                                                                                                    local buf = buffer.fromstring(data)
                                                                                                                    local results, fmt_pos = {}, 1
                                                                                                                    while fmt_pos <= #fmt do
                                                                                                                        local char = fmt:sub(fmt_pos, fmt_pos)
                                                                                                                        if char == '<' or char == '>' or char == '=' then
                                                                                                                            fmt_pos = fmt_pos + 1
                                                                                                                            elseif char == 'I' then
                                                                                                                                fmt_pos = fmt_pos + 1
                                                                                                                                if fmt:sub(fmt_pos, fmt_pos) == '4' then
                                                                                                                                    results[#results+1] = buffer.readu32(buf, buf_offset); buf_offset = buf_offset + 4; fmt_pos = fmt_pos + 1
                                                                                                                                    end
                                                                                                                                    elseif char == 'i' then
                                                                                                                                        fmt_pos = fmt_pos + 1
                                                                                                                                        if fmt:sub(fmt_pos, fmt_pos) == '4' then
                                                                                                                                            results[#results+1] = buffer.readi32(buf, buf_offset); buf_offset = buf_offset + 4; fmt_pos = fmt_pos + 1
                                                                                                                                            end
                                                                                                                                            elseif char == 'f' then
                                                                                                                                                results[#results+1] = buffer.readf32(buf, buf_offset); buf_offset = buf_offset + 4; fmt_pos = fmt_pos + 1
                                                                                                                                                elseif char == 'd' then
                                                                                                                                                    results[#results+1] = buffer.readf64(buf, buf_offset); buf_offset = buf_offset + 8; fmt_pos = fmt_pos + 1
                                                                                                                                                    elseif char == 'b' then
                                                                                                                                                        results[#results+1] = buffer.readi8(buf, buf_offset); buf_offset = buf_offset + 1; fmt_pos = fmt_pos + 1
                                                                                                                                                        elseif char == 'B' then
                                                                                                                                                            results[#results+1] = buffer.readu8(buf, buf_offset); buf_offset = buf_offset + 1; fmt_pos = fmt_pos + 1
                                                                                                                                                            else
                                                                                                                                                                fmt_pos = fmt_pos + 1
                                                                                                                                                                end
                                                                                                                                                                end
                                                                                                                                                                return unpack(results)
                                                                                                                                                                end
                                                                                                                                                                else
                                                                                                                                                                    s_pack = string.pack; s_unpack = string.unpack
                                                                                                                                                                    end
if not s_pack or not s_unpack then
local _msg = "string.pack/string.unpack not available; serialization requires Lua 5.3+ or a buffer implementation"
s_pack = function() error(_msg) end
s_unpack = function() error(_msg) end
end

local function makeSharedStringIdentifier(identifier)
-- SSTR keys are exactly 16 bytes; keep the numeric suffix in the final four bytes.
return s_rep("\0",12)..s_pack("<I4",identifier)
end
--[[
                                                                                                                                                                        local propBypass = {
                                                                                                                                                                        ["BasePart"] = {
                                                                                                                                                                        ["Size"] = true,
                                                                                  ["Color"] = true,
                                                                                  },
                                                                                  ["Part"] = {
                                                                                  ["Shape"] = true
                                                                                  },
                                                                                  ["Fire"] = {
                                                                                  ["Heat"] = true,
                                                                                  ["Size"] = true,
                                                                                  },
                                                                                  ["Smoke"] = {
                                                                                  ["Opacity"] = true,
                                                                                  ["RiseVelocity"] = true,
                                                                                  ["Size"] = true,
                                                                                  },
                                                                                  ["DoubleConstrainedValue"] = {
                                                                                  ["Value"] = true
                                                                                  },
                                                                                  ["IntConstrainedValue"] = {
                                                                                  ["Value"] = true
                                                                                  },
                                                                                  ["TrussPart"] = {
                                                                                  ["Style"] = true
                                                                                  }
                                                                                  }
                                                                                  ]]
                                                                                  local propBypass = {
                                                                                      ["BasePart"] = {
                                                                                          ["Color"] = true, -- No Coloruint8
                                                                                      },
                                                                                  }


                                                                                  local propFilter = {
                                                                                      ["BasePart"] = {
                                                                                          ["Color3uint8"] = true
                                                                                      },
                                                                                      ["BaseScript"] = {
                                                                                          ["LinkedSource"] = true
                                                                                      },
                                                                                      ["Script"] = {
                                                                                          ["Source"] = true
                                                                                      },
                                                                                      ["ModuleScript"] = {
                                                                                          ["LinkedSource"] = true,
                                                                                          ["Source"] = true
                                                                                      },
                                                                                      ["Players"] = {
                                                                                          ["CharacterAutoLoads"] = true
                                                                                      },
                                                                                      ["UserInputService"] = {
                                                                                          ["MouseIconContent"] = true
                                                                                      },
                                                                                      ["BillboardGui"] = {
                                                                                          ["PlayerToHideFrom"] = true
                                                                                      },
                                                                                      ["AudioDeviceInput"] = {
                                                                                          -- Player instances are serialized as Folders by this serializer.
                                                                                          -- Keeping this reference would make the RBXL invalid because
                                                                                          -- AudioDeviceInput.Player only accepts an actual Player.
                                                                                          ["Player"] = true
                                                                                      },
                                                                                      ["Instance"] = {
                                                                                          ["SourceAssetId"] = true,
                                                                                          ["PropertyStatusStudio"] = true
                                                                                      },
                                                                                      ["Model"] = {
                                                                                          ["WorldPivotData"] = true -- No OptionalCoordinateFrame
                                                                                      },
                                                                                      ["MeshPart"] = {
                                                                                          ["MeshId"] = true, -- Replaced by MeshContent
                                                                                          ["TextureID"] = true, -- Replaced by TextureContent
                                                                                      },
                                                                                      ["FileMesh"] = {
                                                                                          ["MeshId"] = true, -- Replaced by MeshContent
                                                                                          ["TextureId"] = true, -- Replaced by TextureContent
                                                                                      },
                                                                                      ["TerrainRegion"] = { -- No Vector3int16
                                                                                          ["ExtentsMax"] = true,
                                                                                          ["ExtentsMin"] = true
                                                                                      }
                                                                                  }

                                                                                  local xmlReplacePattern = "['\"<>&\0]"

                                                                                  local xmlReplace = {
                                                                                      ["'"] = "&apos;",
                                                                                      ["\""] = "&quot;",
                                                                                      ["<"] = "&lt;",
                                                                                      [">"] = "&gt;",
                                                                                      ["&"] = "&amp;",
                                                                                      ["\0"] = ""
                                                                                  }

                                                                                  local serviceBlacklist = {
                                                                                      ["CoreGui"] = true,
                                                                                      ["CorePackages"] = true,
                                                                                      ["UserInputService"] = true,
                                                                                  }

                                                                                  local nilClassParents = {
                                                                                      ["Attachment"] = "Part",
                                                                                      ["Bone"] = "Part",
                                                                                      ["Animator"] = "Humanoid",
                                                                                      ["SurfaceAppearance"] = "MeshPart"
                                                                                  }

                                                                                  local function readContentValue(value)
                                                                                      if value == nil or value == "" then return 0,nil end
                                                                                      if type(value) == "string" then return 1,value end

                                                                                      local ok,sourceType = pcall(function() return value.SourceType end)
                                                                                      if not ok or sourceType == nil then return 0,nil end
                                                                                      local nameOk,sourceName = pcall(function() return sourceType.Name end)
                                                                                      sourceName = nameOk and sourceName or tostring(sourceType):match("%.([^%.]+)$") or tostring(sourceType)
                                                                                      if sourceName == "Uri" then
                                                                                          local uriOk,uri = pcall(function() return value.Uri end)
                                                                                          return uriOk and 1 or 0,uriOk and tostring(uri) or nil
                                                                                      elseif sourceName == "Object" then
                                                                                          local objectOk,object = pcall(function() return value.Object end)
                                                                                          return objectOk and 2 or 0,objectOk and object or nil
                                                                                      end
                                                                                      return 0,nil
                                                                                  end

                                                                                  local valueConverters = {
                                                                                      ["bool"] = function(name,val)
                                                                                      return '\n<bool name="'..name..'">'..(val and "true" or "false")..'</bool>'
                                                                    end,
                                                                    ["int"] = function(name,val)
                                                                    return format('\n<int name="%s">%d</int>',name,val)
                                                                    end,
                                                                    ["int64"] = function(name,val)
                                                                    return format('\n<int64 name="%s">%d</int64>',name,val)
                                                                    end,
                                                                    ["float"] = function(name,val)
                                                                    return format('\n<float name="%s">%.12f</float>',name,val)
                                                                    end,
                                                                    ["double"] = function(name,val)
                                                                    return format('\n<double name="%s">%.12f</double>',name,val)
                                                                    end,
                                                                    ["string"] = function(name,val)
                                                                    return '\n<string name="'..name..'">'..gsub(val,xmlReplacePattern,xmlReplace)..'</string>'
                                                                    end,
                                                                    ["BrickColor"] = function(name,val)
                                                                    return format('\n<int name="%s">%d</int>',name,val.Number)
                                                                    end,
                                                                    ["Vector2"] = function(name,val)
                                                                    return format('\n<Vector2 name="%s">\n<X>%.12f</X>\n<Y>%.12f</Y>\n</Vector2>',name,val.X,val.Y)
                                                                    end,
                                                                    ["Vector3"] = function(name,val)
                                                                    return format('\n<Vector3 name="%s">\n<X>%.12f</X>\n<Y>%.12f</Y>\n<Z>%.12f</Z>\n</Vector3>',name,val.X,val.Y,val.Z)
                                                                    end,
                                                                    ["Vector3int16"] = function(name,val)
                                                                    return format('\n<Vector3int16 name="%s">\n<X>%d</X>\n<Y>%d</Y>\n<Z>%d</Z>\n</Vector3int16>',name,val.X,val.Y,val.Z)
                                                                    end,
                                                                    ["CFrame"] = function(name,val)
                                                                    return format('\n<CoordinateFrame name="%s">\n<X>%.12f</X>\n<Y>%.12f</Y>\n<Z>%.12f</Z>\n<R00>%.12f</R00>\n<R01>%.12f</R01>\n<R02>%.12f</R02>\n<R10>%.12f</R10>\n<R11>%.12f</R11>\n<R12>%.12f</R12>\n<R20>%.12f</R20>\n<R21>%.12f</R21>\n<R22>%.12f</R22>\n</CoordinateFrame>',name,components(val))
                                                                    end,
                                                                    ["Content"] = function(name,val)
                                                                    local sourceType,payload = readContentValue(val)
                                                                    if sourceType == 1 then
                                                                        return '\n<Content name="'..name..'"><uri>'..gsub(payload,xmlReplacePattern,xmlReplace)..'</uri></Content>'
                                                                    end
                                                                    return '\n<Content name="'..name..'"><null></null></Content>'
                                                                    end,
                                                                    ["UDim"] = function(name,val)
                                                                    return format('\n<UDim name="%s">\n<S>%.12f</S>\n<O>%d</O>\n</UDim>',name,val.Scale,val.Offset)
                                                                    end,
                                                                    ["UDim2"] = function(name,val)
                                                                    local x = val.X
                                                                    local y = val.Y
                                                                    return format('\n<UDim2 name="%s">\n<XS>%.12f</XS>\n<XO>%d</XO>\n<YS>%.12f</YS>\n<YO>%d</YO>\n</UDim2>',name,x.Scale,x.Offset,y.Scale,y.Offset)
                                                                    end,
                                                                    ["Color3"] = function(name,val)
                                                                    return format('\n<Color3 name="%s">\n<R>%.12f</R>\n<G>%.12f</G>\n<B>%.12f</B>\n</Color3>',name,val.R,val.G,val.B)
                                                                    end,
                                                                    ["NumberRange"] = function(name,val)
                                                                    return '\n<NumberRange name="'..name..'">'..tostring(val)..'</NumberRange>'
                                                                    end,
                                                                    ["NumberSequence"] = function(name,val)
                                                                    return '\n<NumberSequence name="'..name..'">'..tostring(val)..'</NumberSequence>'
                                                                    end,
                                                                    ["ColorSequence"] = function(name,val)
                                                                    return '\n<ColorSequence name="'..name..'">'..tostring(val)..'</ColorSequence>'
                                                                    end,
                                                                    ["Rect"] = function(name,val)
                                                                    local min,max = val.Min,val.Max
                                                                    return format('\n<Rect2D name="%s">\n<min>\n<X>%.12f</X>\n<Y>%.12f</Y>\n</min>\n<max>\n<X>%.12f</X>\n<Y>%.12f</Y>\n</max>\n</Rect2D>',name,min.X,min.Y,max.X,max.Y)
                                                                    end,
                                                                    ["PhysicalProperties"] = function(name,val)
                                                                    if val then
                                                                        return format('\n<PhysicalProperties name="%s">\n<CustomPhysics>true</CustomPhysics>\n<Density>%.12f</Density>\n<Friction>%.12f</Friction>\n<Elasticity>%.12f</Elasticity>\n<FrictionWeight>%.12f</FrictionWeight>\n<ElasticityWeight>%.12f</ElasticityWeight>\n</PhysicalProperties>',name,val.Density,val.Friction,val.Elasticity,val.FrictionWeight,val.ElasticityWeight)
                                                                        else
                                                                            return '\n<PhysicalProperties name="'..name..'">\n<CustomPhysics>false</CustomPhysics>\n</PhysicalProperties>'
                                                                    end
                                                                    end,
                                                                    ["Faces"] = function(name,val)
                                                                    local faceInt = (val.Front and 32 or 0) + (val.Bottom and 16 or 0) + (val.Left and 8 or 0) + (val.Back and 4 or 0) + (val.Top and 2 or 0) + (val.Right and 1 or 0)
                                                                    return format('\n<Faces name="%s">\n<faces>%d</faces>\n</Faces>',name,faceInt)
                                                                    end,
                                                                    ["Axes"] = function(name,val)
                                                                    local axisInt = (val.Z and 4 or 0) + (val.Y and 2 or 0) + (val.X and 1 or 0)
                                                                    return format('\n<Axes name="%s">\n<axes>%d</axes>\n</Axes>',name,axisInt)
                                                                    end,
                                                                    ["Ray"] = function(name,val)
                                                                    local origin = val.Origin
                                                                    local direction = val.Direction
                                                                    return format('\n<Ray name="%s">\n<origin>\n<X>%.12f</X>\n<Y>%.12f</Y>\n<Z>%.12f</Z>\n</origin>\n<direction>\n<X>%.12f</X>\n<Y>%.12f</Y>\n<Z>%.12f</Z>\n</direction>\n</Ray>',name,origin.X,origin.Y,origin.Z,direction.X,direction.Y,direction.Z)
                                                                    end,
                                                                    ["BinaryString"] = function(name,val)
                                                                    if val then
                                                                        return '\n<BinaryString name="'..name..'"><![CDATA['..val..']]></BinaryString>'
                                                                    else
                                                                        return ""
                                                                        end
                                                                        end,
                                                                        ["ProtectedString"] = function(name,val)
                                                                        return '\n<ProtectedString name="'..name..'">'..gsub(val,xmlReplacePattern,xmlReplace)..'</ProtectedString>'
                                                                    end,
                                                                    ["SharedString"] = function(name,val)
                                                                    return '\n<SharedString name="'..name..'">'..val..'</SharedString>'
                                                                    end,
                                                                    ["SecurityCapabilities"] = function(name,val)
                                                                    return format('\n<SecurityCapabilities name="%s">%d</SecurityCapabilities>',name,val or 0)
                                                                    end,
                                                                                  }

                                                                                  local binaryDataTypes = {
                                                                                      ["string"] = "\1",
                                                                                      ["ContentId"] = "\1",
                                                                                      ["BinaryString"] = "\1",
                                                                                      ["bool"] = "\2",
                                                                                      ["int"] = "\3",
                                                                                      ["float"] = "\4",
                                                                                      ["double"] = "\5",
                                                                                      ["UDim"] = "\6",
                                                                                      ["UDim2"] = "\7",
                                                                                      ["Ray"] = "\8",
                                                                                      ["Faces"] = "\9",
                                                                                      ["Axes"] = "\10",
                                                                                      ["BrickColor"] = "\11",
                                                                                      ["Color3"] = "\12",
                                                                                      ["Vector2"] = "\13",
                                                                                      ["Vector3"] = "\14",
                                                                                      ["CFrame"] = "\16",
                                                                                      ["Enum"] = "\18",
                                                                                      ["Referent"] = "\19",
                                                                                      ["Vector3int16"] = "\20",
                                                                                      ["NumberSequence"] = "\21",
                                                                                      ["ColorSequence"] = "\22",
                                                                                      ["NumberRange"] = "\23",
                                                                                      ["Rect"] = "\24",
                                                                                      ["PhysicalProperties"] = "\25",
                                                                                      ["Color3uint8"] = "\26",
                                                                                      ["int64"] = "\27",
                                                                                      ["SharedString"] = "\28",
                                                                                      ["OptionalCoordinateFrame"] = "\30",
                                                                                      ["Font"] = "\32"
                                                                                  }

                                                                                  binaryDataTypes.Content = "\34"

                                                                                  -- Modern CSG payloads use these names for data encoded by existing descriptors.
                                                                                  valueConverters.ContentId = function(name,val)
                                                                                      if val == nil or val == "" then
                                                                                          return '\n<ContentId name="'..name..'"><null></null></ContentId>'
                                                                                      end
                                                                                      return '\n<ContentId name="'..name..'"><url>'..gsub(val,xmlReplacePattern,xmlReplace)..'</url></ContentId>'
                                                                                  end
                                                                                  valueConverters.NetAssetRef = function(name,val)
                                                                                      return '\n<NetAssetRef name="'..name..'">'..val..'</NetAssetRef>'
                                                                                  end
                                                                                  binaryDataTypes.NetAssetRef = binaryDataTypes.SharedString

                                                                                  local binaryCFrameMap = {
                                                                                      ["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = "\2",
                                                                                      ["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0"] = "\3",
                                                                                      ["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = "\5",
                                                                                      ["\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0"] = "\6",
                                                                                      ["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = "\7",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = "\9",
                                                                                      ["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63"] = "\10",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = "\12",
                                                                                      ["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0"] = "\13",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0"] = "\14",
                                                                                      ["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0"] = "\16",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128"] = "\17",
                                                                                      ["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = "\20",
                                                                                      ["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128"] = "\21",
                                                                                      ["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = "\23",
                                                                                      ["\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128"] = "\24",
                                                                                      ["\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = "\25",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = "\27",
                                                                                      ["\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191"] = "\28",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = "\30",
                                                                                      ["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0"] = "\31",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0"] = "\32",
                                                                                      ["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0"] = "\34",
                                                                                      ["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128"] = "\35",
                                                                                  }

                                                                                  local binaryPropHandlers = {
                                                                                      ["string"] = function(objs,name,func)
                                                                                      local szObjs = #objs
                                                                                      local result = tableCreate(szObjs)
                                                                                      for i = 1,szObjs do
                                                                                          local val
                                                                                          if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                              result[i] = s_pack("<I4",#val)..val
                                                                                              end
                                                                                              return concat(result)
                                                                                              end,
                                                                                              ["ContentId"] = function(objs,name,func)
                                                                                              local szObjs = #objs
                                                                                              local result = tableCreate(szObjs)
                                                                                              for i = 1,szObjs do
                                                                                                  local val
                                                                                                  if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                      --if sub(val,1,15) == "rbxgameasset://" then -- This doesn't load anymore
                                                                                                      --val = format("https://assetdelivery.roblox.com/v1/asset?universeId=%d&assetName=%s&skipSigningScripts=1",gameId,urlEncode(httpService,sub(val,16)))
                                                                    --end
                                                                    result[i] = s_pack("<I4",#val)..val
                                                                    end
                                                                    return concat(result)
                                                                    end,
                                                                    ["BinaryString"] = function(objs,name,func)
                                                                    if not func and not getbspval then return end

                                                                    local szObjs = #objs
                                                                    local result = tableCreate(szObjs)
                                                                    for i = 1,szObjs do
                                                                            local val = func and func(objs[i],name) or getbspval(objs[i],name) or ""

                                                                            result[i] = s_pack("<I4",#val)..val
                                                                        end
                                                                        return concat(result)
                                                                    end,
                                                                            ["bool"] = function(objs,name,func)
                                                                            local szObjs = #objs
                                                                            local result = tableCreate(szObjs)
                                                                            for i = 1,szObjs do
                                                                                local val
                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                    result[i] = val and "\1" or "\0"
                                                                                    end
                                                                                    return concat(result)
                                                                                    end,
                                                                                    ["int"] = function(objs,name,func)
                                                                                    local szObjs = #objs
                                                                                    local result = tableCreate(4*szObjs)
                                                                                    local sep = szObjs-1
                                                                                    for i = 1,szObjs do
                                                                                        local start = i-1
                                                                                        local val
                                                                                        if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                            local bytes = s_pack(">I4", val < 0 and 2 * -val - 1 or 2 * val)
                                                                                            for b = 1,4 do
                                                                                                result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                end
                                                                                                end
                                                                                                return concat(result)
                                                                                                end,
                                                                                                ["float"] = function(objs,name,func)
                                                                                                local szObjs = #objs
                                                                                                local result = tableCreate(4*szObjs)
                                                                                                local sep = szObjs-1
                                                                                                for i = 1,szObjs do
                                                                                                    local start = i-1
                                                                                                    local val
                                                                                                    if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                        local bytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val)), 1))
                                                                                                        for b = 1,4 do
                                                                                                            result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                            end
                                                                                                            end
                                                                                                            return concat(result)
                                                                                                            end,
                                                                                                            ["double"] = function(objs,name,func)
                                                                                                            local szObjs = #objs
                                                                                                            local result = tableCreate(szObjs)
                                                                                                            for i = 1,szObjs do
                                                                                                                local val
                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                    result[i] = s_pack("<d", val)
                                                                                                                    end
                                                                                                                    return concat(result)
                                                                                                                    end,
                                                                                                                    ["UDim"] = function(objs,name,func)
                                                                                                                    local szObjs = #objs
                                                                                                                    local result = tableCreate(2*4*szObjs)
                                                                                                                    local sep = szObjs-1
                                                                                                                    local firstArrayEnd = 4*szObjs
                                                                                                                    for i = 1,szObjs do
                                                                                                                        local scaleStart = i-1
                                                                                                                        local offsetStart = firstArrayEnd + i-1

                                                                                                                        local val
                                                                                                                        if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                            local offset = val.Offset

                                                                                                                            local scaleBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.Scale)), 1))
                                                                                                                            local offsetBytes = s_pack(">I4", offset < 0 and 2 * -offset - 1 or 2 * offset)

                                                                                                                            for b = 1,4 do
                                                                                                                                result[scaleStart + b + sep*(b-1)] = sub(scaleBytes,b,b)
                                                                                                                                result[offsetStart + b + sep*(b-1)] = sub(offsetBytes,b,b)
                                                                                                                                end
                                                                                                                                end
                                                                                                                                return concat(result)
                                                                                                                                end,
                                                                                                                                ["UDim2"] = function(objs,name,func)
                                                                                                                                local szObjs = #objs
                                                                                                                                local result = tableCreate(4*4*szObjs)
                                                                                                                                local sep = szObjs-1
                                                                                                                                local firstArrayEnd = 4*szObjs
                                                                                                                                local secondArrayEnd = 2*4*szObjs
                                                                                                                                local thirdArrayEnd = 3*4*szObjs
                                                                                                                                for i = 1,szObjs do
                                                                                                                                    local xScaleStart = i-1
                                                                                                                                    local yScaleStart = firstArrayEnd + i-1
                                                                                                                                    local xOffsetStart = secondArrayEnd + i-1
                                                                                                                                    local yOffsetStart = thirdArrayEnd + i-1

                                                                                                                                    local val
                                                                                                                                    if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                                        local x,y = val.X,val.Y

                                                                                                                                        local xOffset = x.Offset
                                                                                                                                        local yOffset = y.Offset

                                                                                                                                        local xScaleBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", x.Scale)), 1))
                                                                                                                                        local xOffsetBytes = s_pack(">I4", xOffset < 0 and 2 * -xOffset - 1 or 2 * xOffset)
                                                                                                                                        local yScaleBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", y.Scale)), 1))
                                                                                                                                        local yOffsetBytes = s_pack(">I4", yOffset < 0 and 2 * -yOffset - 1 or 2 * yOffset)

                                                                                                                                        for b = 1,4 do
                                                                                                                                            result[xScaleStart + b + sep*(b-1)] = sub(xScaleBytes,b,b)
                                                                                                                                            result[xOffsetStart + b + sep*(b-1)] = sub(xOffsetBytes,b,b)
                                                                                                                                            result[yScaleStart + b + sep*(b-1)] = sub(yScaleBytes,b,b)
                                                                                                                                            result[yOffsetStart + b + sep*(b-1)] = sub(yOffsetBytes,b,b)
                                                                                                                                            end
                                                                                                                                            end
                                                                                                                                            return concat(result)
                                                                                                                                            end,
                                                                                                                                            ["Ray"] = function(objs,name,func)
                                                                                                                                            local szObjs = #objs
                                                                                                                                            local result = tableCreate(szObjs)
                                                                                                                                            for i = 1,szObjs do
                                                                                                                                                local val
                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                                                    local origin = val.Origin
                                                                                                                                                    local dir = val.Direction
                                                                                                                                                    result[i] = s_pack("<ffffff", origin.X, origin.Y, origin.Z, dir.X, dir.Y, dir.Z)
                                                                                                                                                    end
                                                                                                                                                    return concat(result)
                                                                                                                                                    end,
                                                                                                                                                    ["Faces"] = function(objs,name,func)
                                                                                                                                                    local szObjs = #objs
                                                                                                                                                    local result = tableCreate(szObjs)
                                                                                                                                                    for i = 1,szObjs do
                                                                                                                                                        local val
                                                                                                                                                        if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                            local faceInt = (val.Front and 32 or 0) + (val.Bottom and 16 or 0) + (val.Left and 8 or 0) + (val.Back and 4 or 0) + (val.Top and 2 or 0) + (val.Right and 1 or 0)
                                                                                                                                                            result[i] = s_pack("b", faceInt)
                                                                                                                                                            end
                                                                                                                                                            return concat(result)
                                                                                                                                                            end,
                                                                                                                                                            ["Axes"] = function(objs,name,func)
                                                                                                                                                            local szObjs = #objs
                                                                                                                                                            local result = tableCreate(szObjs)
                                                                                                                                                            for i = 1,szObjs do
                                                                                                                                                                local val
                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                    local axisInt = (val.Z and 4 or 0) + (val.Y and 2 or 0) + (val.X and 1 or 0)
                                                                                                                                                                    result[i] = s_pack("b", axisInt)
                                                                                                                                                                    end
                                                                                                                                                                    return concat(result)
                                                                                                                                                                    end,
                                                                                                                                                                    ["BrickColor"] = function(objs,name,func)
                                                                                                                                                                    local szObjs = #objs
                                                                                                                                                                    local result = tableCreate(4*szObjs)
                                                                                                                                                                    local sep = szObjs-1
                                                                                                                                                                    for i = 1,szObjs do
                                                                                                                                                                        local start = i-1
                                                                                                                                                                        local val
                                                                                                                                                                        if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                                                                            local bytes = s_pack(">I4", val.Number)
                                                                                                                                                                            for b = 1,4 do
                                                                                                                                                                                result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                                                                                                end
                                                                                                                                                                                end
                                                                                                                                                                                return concat(result)
                                                                                                                                                                                end,
                                                                                                                                                                                ["Color3"] = function(objs,name,func)
                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                local result = tableCreate(3*4*szObjs)
                                                                                                                                                                                local sep = szObjs-1
                                                                                                                                                                                local firstArrayEnd = 4*szObjs
                                                                                                                                                                                local secondArrayEnd = 8*szObjs
                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                    local rStart = i-1
                                                                                                                                                                                    local gStart = firstArrayEnd + i-1
                                                                                                                                                                                    local bStart = secondArrayEnd + i-1

                                                                                                                                                                                    local val
                                                                                                                                                                                    if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                        local rBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.R)), 1))
                                                                                                                                                                                        local gBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.G)), 1))
                                                                                                                                                                                        local bBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.B)), 1))

                                                                                                                                                                                        for b = 1,4 do
                                                                                                                                                                                            result[rStart + b + sep*(b-1)] = sub(rBytes,b,b)
                                                                                                                                                                                            result[gStart + b + sep*(b-1)] = sub(gBytes,b,b)
                                                                                                                                                                                            result[bStart + b + sep*(b-1)] = sub(bBytes,b,b)
                                                                                                                                                                                            end
                                                                                                                                                                                            end
                                                                                                                                                                                            return concat(result)
                                                                                                                                                                                            end,
                                                                                                                                                                                            ["Vector2"] = function(objs,name,func)
                                                                                                                                                                                            local szObjs = #objs
                                                                                                                                                                                            local result = tableCreate(2*4*szObjs)
                                                                                                                                                                                            local sep = szObjs-1
                                                                                                                                                                                            local firstArrayEnd = 4*szObjs
                                                                                                                                                                                            for i = 1,szObjs do
                                                                                                                                                                                                local xStart = i-1
                                                                                                                                                                                                local yStart = firstArrayEnd + i-1

                                                                                                                                                                                                local val
                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                    local xBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.X)), 1))
                                                                                                                                                                                                    local yBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.Y)), 1))

                                                                                                                                                                                                    for b = 1,4 do
                                                                                                                                                                                                        result[xStart + b + sep*(b-1)] = sub(xBytes,b,b)
                                                                                                                                                                                                        result[yStart + b + sep*(b-1)] = sub(yBytes,b,b)
                                                                                                                                                                                                        end
                                                                                                                                                                                                        end
                                                                                                                                                                                                        return concat(result)
                                                                                                                                                                                                        end,
                                                                                                                                                                                                        ["Vector3"] = function(objs,name,func)
                                                                                                                                                                                                        local szObjs = #objs
                                                                                                                                                                                                        local result = tableCreate(3*4*szObjs)
                                                                                                                                                                                                        local sep = szObjs-1
                                                                                                                                                                                                        local firstArrayEnd = 4*szObjs
                                                                                                                                                                                                        local secondArrayEnd = 8*szObjs
                                                                                                                                                                                                        for i = 1,szObjs do
                                                                                                                                                                                                            local xStart = i-1
                                                                                                                                                                                                            local yStart = firstArrayEnd + i-1
                                                                                                                                                                                                            local zStart = secondArrayEnd + i-1

                                                                                                                                                                                                            local val
                                                                                                                                                                                                            if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                local xBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.X)), 1))
                                                                                                                                                                                                                local yBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.Y)), 1))
                                                                                                                                                                                                                local zBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", val.Z)), 1))

                                                                                                                                                                                                                for b = 1,4 do
                                                                                                                                                                                                                    result[xStart + b + sep*(b-1)] = sub(xBytes,b,b)
                                                                                                                                                                                                                    result[yStart + b + sep*(b-1)] = sub(yBytes,b,b)
                                                                                                                                                                                                                    result[zStart + b + sep*(b-1)] = sub(zBytes,b,b)
                                                                                                                                                                                                                    end
                                                                                                                                                                                                                    end
                                                                                                                                                                                                                    return concat(result)
                                                                                                                                                                                                                    end,
                                                                                                                                                                                                                    ["CFrame"] = function(objs,name,func)
                                                                                                                                                                                                                    local szObjs = #objs
                                                                                                                                                                                                                    local result = tableCreate(szObjs + 3*4*szObjs)
                                                                                                                                                                                                                    local sep = szObjs-1
                                                                                                                                                                                                                    local posStart = szObjs
                                                                                                                                                                                                                    local firstArrayEnd = posStart + 4*szObjs
                                                                                                                                                                                                                    local secondArrayEnd = posStart + 8*szObjs
                                                                                                                                                                                                                    for i = 1,szObjs do
                                                                                                                                                                                                                        local xStart = posStart + i-1
                                                                                                                                                                                                                        local yStart = firstArrayEnd + i-1
                                                                                                                                                                                                                        local zStart = secondArrayEnd + i-1

                                                                                                                                                                                                                        local val
                                                                                                                                                                                                                        if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                            local componentStr = s_pack("<fffffffff",select(4,components(val)))
                                                                                                                                                                                                                            result[i] = binaryCFrameMap[componentStr] or "\0"..componentStr

                                                                                                                                                                                                                            local pos = val.Position
                                                                                                                                                                                                                            local xBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", pos.X)), 1))
                                                                                                                                                                                                                            local yBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", pos.Y)), 1))
                                                                                                                                                                                                                            local zBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", pos.Z)), 1))

                                                                                                                                                                                                                            for b = 1,4 do
                                                                                                                                                                                                                                result[xStart + b + sep*(b-1)] = sub(xBytes,b,b)
                                                                                                                                                                                                                                result[yStart + b + sep*(b-1)] = sub(yBytes,b,b)
                                                                                                                                                                                                                                result[zStart + b + sep*(b-1)] = sub(zBytes,b,b)
                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                end,
                                                                                                                                                                                                                                ["Enum"] = function(objs,name,func)
                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                local result = tableCreate(4*szObjs)
                                                                                                                                                                                                                                local sep = szObjs-1
                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                    local start = i-1
                                                                                                                                                                                                                                    local val
                                                                                                                                                                                                                                    if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                                                                                                                                        local bytes = s_pack(">I4", val.Value)
                                                                                                                                                                                                                                        for b = 1,4 do
                                                                                                                                                                                                                                            result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            return concat(result)
                                                                                                                                                                                                                                            end,
                                                                                                                                                                                                                                            ["Vector3int16"] = function(objs,name,func)
                                                                                                                                                                                                                                            local szObjs = #objs
                                                                                                                                                                                                                                            local result = tableCreate(szObjs)
                                                                                                                                                                                                                                            for i = 1,szObjs do
                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                    result[i] = s_pack("<i2i2i2", val.X, val.Y, val.Z)
                                                                                                                                                                                                                                                    end
                                                                                                                                                                                                                                                    return concat(result)
                                                                                                                                                                                                                                                    end,
                                                                                                                                                                                                                                                    ["NumberSequence"] = function(objs,name,func)
                                                                                                                                                                                                                                                    local szObjs = #objs
                                                                                                                                                                                                                                                    local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                    for i = 1,szObjs do
                                                                                                                                                                                                                                                        local val
                                                                                                                                                                                                                                                        if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                            local numKeypoints = #val.Keypoints
                                                                                                                                                                                                                                                            result[i] = s_pack("<I4"..s_rep("fff",numKeypoints), numKeypoints, unpack(split(tostring(val)," ")))
                                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                                            return concat(result)
                                                                                                                                                                                                                                                            end,
                                                                                                                                                                                                                                                            ["ColorSequence"] = function(objs,name,func)
                                                                                                                                                                                                                                                            local szObjs = #objs
                                                                                                                                                                                                                                                            local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                            for i = 1,szObjs do
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                                local numKeypoints = #val.Keypoints
                                                                                                                                                                                                                                                                result[i] = s_pack("<I4"..s_rep("fffff",numKeypoints), numKeypoints, unpack(split(tostring(val)," ")))
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
                                                                                                                                                                                                                                                                ["NumberRange"] = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                                result[i] = s_pack("<ff", val.Min, val.Max)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
                                                                                                                                                                                                                                                                ["Rect"] = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(4*4*szObjs)
                                                                                                                                                                                                                                                                local sep = szObjs-1
                                                                                                                                                                                                                                                                local firstArrayEnd = 4*szObjs
                                                                                                                                                                                                                                                                local secondArrayEnd = 2*4*szObjs
                                                                                                                                                                                                                                                                local thirdArrayEnd = 3*4*szObjs
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local xMinStart = i-1
                                                                                                                                                                                                                                                                local yMinStart = firstArrayEnd + i-1
                                                                                                                                                                                                                                                                local xMaxStart = secondArrayEnd + i-1
                                                                                                                                                                                                                                                                local yMaxStart = thirdArrayEnd + i-1

                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                                local min = val.Min
                                                                                                                                                                                                                                                                local max = val.Max

                                                                                                                                                                                                                                                                local xMinBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", min.X)), 1))
                                                                                                                                                                                                                                                                local yMinBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", min.Y)), 1))
                                                                                                                                                                                                                                                                local xMaxBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", max.X)), 1))
                                                                                                                                                                                                                                                                local yMaxBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", max.Y)), 1))

                                                                                                                                                                                                                                                                for b = 1,4 do
                                                                                                                                                                                                                                                                result[xMinStart + b + sep*(b-1)] = sub(xMinBytes,b,b)
                                                                                                                                                                                                                                                                result[yMinStart + b + sep*(b-1)] = sub(yMinBytes,b,b)
                                                                                                                                                                                                                                                                result[xMaxStart + b + sep*(b-1)] = sub(xMaxBytes,b,b)
                                                                                                                                                                                                                                                                result[yMaxStart + b + sep*(b-1)] = sub(yMaxBytes,b,b)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
                                                                                                                                                                                                                                                                ["PhysicalProperties"] = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                                if val then
                                                                                                                                                                                                                                                                result[i] = "\1"..s_pack("<fffff", val.Density, val.Friction, val.Elasticity, val.FrictionWeight, val.ElasticityWeight)
                                                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                                                result[i] = "\0"
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
                                                                                                                                                                                                                                                                ["Color3uint8"] = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                                result[i] = "\1"..s_pack("<bbb", val.R, val.G, val.B)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
                                                                                                                                                                                                                                                                ["int64"] = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(8*szObjs)
                                                                                                                                                                                                                                                                local sep = szObjs-1
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local start = i-1
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                                                                                                                                                                local bytes = s_pack(">I8", val < 0 and 2 * -val - 1 or 2 * val)
                                                                                                                                                                                                                                                                for b = 1,8 do
                                                                                                                                                                                                                                                                result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
["OptionalCoordinateFrame"] = function(objs,name,func)
local szObjs = #objs
local rotations = tableCreate(szObjs)
local xValues = tableCreate(4*szObjs)
local yValues = tableCreate(4*szObjs)
local zValues = tableCreate(4*szObjs)
local existsValues = tableCreate(szObjs)
local sep = szObjs-1

for i = 1,szObjs do
local val
if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

local exists = val ~= nil
if not exists then val = CFrame.new() end

local componentStr = s_pack("<fffffffff",select(4,components(val)))
rotations[i] = binaryCFrameMap[componentStr] or "\0"..componentStr

local pos = val.Position
local xBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", pos.X)), 1))
local yBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", pos.Y)), 1))
local zBytes = s_pack(">I4", lrotate(s_unpack(">I4", s_pack(">f", pos.Z)), 1))
local start = i-1

for b = 1,4 do
local index = start + b + sep*(b-1)
xValues[index] = sub(xBytes,b,b)
yValues[index] = sub(yBytes,b,b)
zValues[index] = sub(zBytes,b,b)
end

existsValues[i] = exists and "\1" or "\0"
end

-- OptionalCoordinateFrame contains a nested CFrame stream followed by a nested
-- Bool stream. Without 0x10, the first rotation ID is misread as the format.
return "\16"..concat(rotations)..concat(xValues)..concat(yValues)..concat(zValues).."\2"..concat(existsValues)
end,
                                                                                                                                                                                                                                                                ["Font"] = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end

                                                                                                                                                                                                                                                                local family = s_pack("<I4",#val.Family)..val.Family
                                                                                                                                                                                                                                                                local weight = s_pack("<I2",val.Weight.Value)
                                                                                                                                                                                                                                                                local style = s_pack("<I1",val.Style.Value)
                                                                                                                                                                                                                                                                local cached = "\0\0\0\0"--s_pack("<I4",0)..""

                                                                                                                                                                                                                                                                result[i] = family..weight..style..cached
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end,
                                                                                  }

                                                                                  local specialProps = {
                                                                                      ["Script"] = {
                                                                                          {Name = "Source", ValueType = {Name = "ProtectedString", Category = "DataType"}, Special = "Decompile"}
                                                                                      },
                                                                                  ["ModuleScript"] = {
                                                                                      {Name = "Source", ValueType = {Name = "ProtectedString", Category = "DataType"}, Special = "Decompile"}
                                                                                  },
                                                                                  ["TerrainRegion"] = { -- TODO: Vector3int16 support for gethiddenprop
                                                                                      {Name = "ExtentsMin", ValueType = {Name = "Vector3int16", Category = "DataType"}, Special = "Func", Func = function(obj) return workspace.Terrain.MaxExtents.Min end},
                                                                                  {Name = "ExtentsMax", ValueType = {Name = "Vector3int16", Category = "DataType"}, Special = "Func", Func = function(obj) return workspace.Terrain.MaxExtents.Max end},
                                                                                  },
["TriangleMeshPart"] = {
{Name = "CollisionFidelity", ValueType = {Name = "CollisionFidelity", Category = "Enum"}, Special = "NotScriptable"},
{Name = "AeroMeshData", ValueType = {Name = "SharedString", Category = "DataType"}, Special = "SharedString"},
{Name = "PhysicalConfigData", ValueType = {Name = "SharedString", Category = "DataType"}, Special = "SharedString"},
},
["MeshPart"] = {
{Name = "InitialSize", ValueType = {Name = "Vector3", Category = "DataType"}, Special = "NotScriptable"},
{Name = "PhysicsData", ValueType = {Name = "BinaryString", Category = "DataType"}, Special = "BinaryString"},
},
["EditableMesh"] = {
{Name = "MeshData", ValueType = {Name = "SharedString", Category = "DataType"}, Special = "SharedString"},
},
["PartOperation"] = {
{Name = "AssetId", ValueType = {Name = "ContentId", Category = "DataType"}, Special = "NotScriptable"},
{Name = "ChildData", ValueType = {Name = "BinaryString", Category = "DataType"}, Special = "BinaryString"},
{Name = "ChildData2", ValueType = {Name = "SharedString", Category = "DataType"}, Special = "SharedString"},
{Name = "ComponentIndex", ValueType = {Name = "int", Category = "Primitive"}, Special = "NotScriptable"},
{Name = "FormFactor", ValueType = {Name = "FormFactor", Category = "Enum"}, Special = "NotScriptable"},
{Name = "InitialSize", ValueType = {Name = "Vector3", Category = "DataType"}, Special = "NotScriptable"},
{Name = "MeshData", ValueType = {Name = "BinaryString", Category = "DataType"}, Special = "BinaryString"},
{Name = "MeshData2", ValueType = {Name = "SharedString", Category = "DataType"}, Special = "SharedString"},
{Name = "OffCentered", ValueType = {Name = "bool", Category = "Primitive"}, Special = "NotScriptable"},
{Name = "PhysicsData", ValueType = {Name = "BinaryString", Category = "DataType"}, Special = "BinaryString"},
{Name = "SolidMeshHolder", ValueType = {Name = "NetAssetRef", Category = "DataType"}, Special = "SharedString"},
},
}

                                                                                  --[[
                                                                                  local specialProps = {
                                                                                  ["Instance"] = {
                                                                                  {Name = "AttributesSerialize", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "Tags", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  },
                                                                                  ["TriangleMeshPart"] = {
                                                                                  {Name = "LODData", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "PhysicalConfigData", ValueType = {Name = "SharedString"}, Special = "SharedString"},
                                                                                  },
                                                                                  ["PartOperation"] = {
                                                                                  {Name = "AssetId", ValueType = {Name = "Content"}, Special = "NotScriptable"},
                                                                                  {Name = "InitialSize", ValueType = {Name = "Vector3"}, Special = "NotScriptable"},
                                                                                  {Name = "ChildData", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "MeshData", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "PhysicsData", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "ChildData2", ValueType = {Name = "SharedString"}, Special = "SharedString"},
                                                                                  {Name = "MeshData2", ValueType = {Name = "SharedString"}, Special = "SharedString"},
                                                                                  {Name = "FormFactor", ValueType = {Name = "FormFactor", Category = "Enum"}, Special = "NotScriptable"},
                                                                                  },
                                                                                  ["MeshPart"] = {
                                                                                  {Name = "InitialSize", ValueType = {Name = "Vector3"}, Special = "NotScriptable"},
                                                                                  {Name = "PhysicsData", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  },
                                                                                  ["Terrain"] = {
                                                                                  {Name = "Decoration", ValueType = {Name = "bool"}, Special = "NotScriptable"},
                                                                                  {Name = "MaterialColors", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "SmoothGrid", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "PhysicsGrid", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  },
                                                                                  ["TerrainRegion"] = { -- TODO: Vector3int16 support for gethiddenprop
                                                                                  {Name = "SmoothGrid", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  {Name = "ExtentsMin", ValueType = {Name = "Vector3int16"}, Special = "Func", Func = function(obj) return workspace.Terrain.MaxExtents.Min end},
                                                                                  {Name = "ExtentsMax", ValueType = {Name = "Vector3int16"}, Special = "Func", Func = function(obj) return workspace.Terrain.MaxExtents.Max end},
                                                                                  },
                                                                                  ["BinaryStringValue"] = {
                                                                                  {Name = "Value", ValueType = {Name = "BinaryString"}, Special = "BinaryString"},
                                                                                  },
                                                                                  ["Workspace"] = {
                                                                                  {Name = "PGSPhysicsSolverEnabled", ValueType = {Name = "bool"}, Special = "Func", Func = function(obj) return obj:PGSIsEnabled() end},
                                                                                  {Name = "CollisionGroups", ValueType = {Name = "string"}, Special = "Func", Func = function(obj)
                                                                    local groupTable = {}
                                                                    for i,v in pairs(game:GetService("PhysicsService"):GetCollisionGroups()) do
                                                                        groupTable[i] = v.name.."^"..v.id.."^"..v.mask
                                                                        end
                                                                        return table.concat(groupTable,"\\")
                                                                    end}
                                                                    },
                                                                    ["Humanoid"] = {
                                                                    {Name = "Health_XML", ValueType = {Name = "float"}, IndexName = "Health"},
                                                                    },
                                                                    ["Sound"] = {
                                                                    {Name = "xmlRead_MaxDistance_3", ValueType = {Name = "float"}, IndexName = "MaxDistance"},
                                                                    },
                                                                    ["WeldConstraint"] = {
                                                                    {Name = "CFrame0", ValueType = {Name = "CFrame"}, Special = "NotScriptable"},
                                                                    {Name = "CFrame1", ValueType = {Name = "CFrame"}, Special = "NotScriptable"},
                                                                    {Name = "Part0Internal", ValueType = {Name = "Instance"}, IndexName = "Part0"},
                                                                    {Name = "Part1Internal", ValueType = {Name = "Instance"}, IndexName = "Part1"}
                                                                    },
                                                                    ["Lighting"] = {
                                                                    {Name = "Technology", ValueType = {Category = "Enum"}, Special = "NotScriptable"}
                                                                    },
                                                                    ["LocalizationTable"] = {
                                                                    {Name = "Contents", ValueType = {Name = "string"}, Special = "NotScriptable"}
                                                                    },
                                                                    ["Script"] = {
                                                                    {Name = "Source", ValueType = {Name = "ProtectedString"}, Special = "Decompile"}
                                                                    },
                                                                    ["ModuleScript"] = {
                                                                    {Name = "Source", ValueType = {Name = "ProtectedString"}, Special = "Decompile"}
                                                                    },
                                                                    ["PackageLink"] = {
                                                                    {Name = "PackageIdSerialize", ValueType = {Name = "Content"}, IndexName = "PackageId"},
                                                                    {Name = "VersionIdSerialize", ValueType = {Name = "int64"}, IndexName = "VersionNumber"}
                                                                    }
                                                                    }
                                                                    ]]

                                                                    local readMeStart = [==[--[[
                                                                        === DexSerializer SaveInstance ===

                                                                        Thank you for using DexSerializer!

                                                                        -- Saved with https://github.com/Tesker-103/DexRecontinued/

                                                                        IMPORTANT NOTES:
                                                                        - Save your game immediately (Use File > Save As) to take advantage of the chosen format.
                                                                        - If your player cannot spawn, move scripts in StarterPlayer to another location (done by default).
                                                                        - If chat doesn't work, delete everything in Chat service via:
                                                                        game:GetService("Chat"):ClearAllChildren()

                                                                        FOR PHYSICS/COLLISION ISSUES (UnionOperation & MeshPart):
                                                                        Run this in Studio command bar:
                                                                        local list = {}
                                                                        for i,v in pairs(game:GetDescendants()) do
                                                                            local s,e = pcall(function()
                                                                            return v:IsA("UnionOperation") or v:IsA("MeshPart")
                                                                            end)
                                                                            if s and e then list[#list+1] = v end
                                                                                end
                                                                                game.Selection:Set(list)

                                                                                Then go to Properties and change CollisionFidelity from "Box" to "Default".

                                                                                SETTINGS USED FOR THIS SAVE:

                                                                    ]==]

local function getSaveProps(obj,class)
local result = {}
local resultIndexes = {}
local count = 1

                                                                    local curClass = API.Classes[class]
                                                                    while curClass do
                                                                        local curClassName = curClass.Name
                                                                        local cacheProps = saveProps[curClassName]
if cacheProps then
table.move(cacheProps,1,#cacheProps,#result+1,result)
for i = 1,#result do
resultIndexes[result[i].Name] = i
end
break
                                                                            end

                                                                            local props = curClass.Properties
                                                                            for i = 1,#props do
                                                                                local prop = props[i]
                                                                                local propName = prop.Name
                                                                                --if (prop.Serialization.CanSave and not prop.Tags.NotScriptable) or (propBypass[curClassName] and propBypass[curClassName][propName]) then
                                                                                if prop.Serialization.CanSave or (propBypass[curClassName] and propBypass[curClassName][propName]) then
                                                                                    if not propFilter[curClassName] or not propFilter[curClassName][propName] then
                                                                                        -- Check for existence in current engine version
                                                                                        if prop.Tags and prop.Tags.NotScriptable then
                                                                                            local s,ret1,ret2 = pcall(getnspval,obj,propName)
if s and type(ret2) ~= "string" then
if not resultIndexes[propName] then
result[count] = prop
resultIndexes[propName] = count
count = count + 1
end
end
else
local s,e = pcall(function() return obj[propName] end)
if s then
if not resultIndexes[propName] then
result[count] = prop
resultIndexes[propName] = count
count = count + 1
end
end
                                                                                                        end
                                                                                                        end
                                                                                                        end
                                                                                                        end

                                                                                                        -- Special props may also contain alternate defs for filtered props
local specialProps = specialProps[curClassName]
if specialProps then
for i = 1,#specialProps do
local prop = specialProps[i]
local existingIndex = resultIndexes[prop.Name]
if existingIndex then
result[existingIndex] = prop
else
result[count] = prop
resultIndexes[prop.Name] = count
count = count + 1
end
end
end

                                                                                                            curClass = curClass.Superclass
                                                                                                            end

table.sort(result,function(a,b) return a.Name < b.Name end)
return result
end

local function apiClassIsA(className,ancestorName)
local currentClass = API.Classes[className]
while currentClass do
if currentClass.Name == ancestorName then return true end
currentClass = currentClass.Superclass
end
return false
end

local hiddenPropertyAliases = {
InitialSize = {"MeshSize"},
FormFactor = {"formFactorRaw","formFactor"},
}

local optionalUnionProperties = {
SolidMeshHolder = true,
}

local function directPropertyReader(obj,propName)
if oldIndex then return oldIndex(obj,propName) end
return obj[propName]
end

local function tryPropertyReaders(obj,propName,...)
for i = 1,select("#",...) do
local reader = select(i,...)
if reader then
local ok,value = pcall(reader,obj,propName)
if ok and value ~= nil then return true,value end
end
end

local ok,value = pcall(directPropertyReader,obj,propName)
if ok and value ~= nil then return true,value end

local aliases = hiddenPropertyAliases[propName]
if aliases then
for i = 1,#aliases do
ok,value = pcall(directPropertyReader,obj,aliases[i])
if ok and value ~= nil then return true,value end
end
end
return false,nil
end

local function normalizePropertyValue(value,typeData)
if value == nil then return nil end
local valueType = typeData.Name
if valueType == "BinaryString" or valueType == "SharedString" or valueType == "NetAssetRef" then
if type(value) == "string" then return value end
local bufferLibrary = rawget(_G,"buffer")
if bufferLibrary and bufferLibrary.tostring then
local ok,result = pcall(bufferLibrary.tostring,value)
if ok then return result end
end
elseif valueType == "ContentId" and type(value) ~= "string" then
local ok,uri = pcall(function() return value.Uri end)
if ok and uri ~= nil then return tostring(uri) end
return tostring(value)
end
return value
end

local function formatUnionFailures(failureKeys)
local counts = {}
for _,failures in pairs(failureKeys) do
for propName in pairs(failures) do
counts[propName] = (counts[propName] or 0) + 1
end
end
local names = {}
for propName,count in pairs(counts) do
names[#names+1] = count > 1 and (propName.." x"..count) or propName
end
table.sort(names)
return concat(names,", ")
end

local function getTestInst(class)
                                                                                                            local s,inst = pcall(Instance.new,class)
                                                                                                            if not s then return {} end

                                                                                                                local defaultProps = {}

                                                                                                                local props = saveProps[class]
                                                                                                                for i = 1,#props do
                                                                                                                    local prop = props[i]
                                                                                                                    if not prop.Special and not (prop.Tags and prop.Tags.NotScriptable) then
                                                                                                                        local propName = prop.IndexName or prop.Name
                                                                                                                        defaultProps[propName] = inst[propName]
                                                                                                                        end
                                                                                                                        end

                                                                                                                        return defaultProps
                                                                                                                        end

                                                                                                                        local function doDecompile(scr,saveSettings)
                                                                                                                        local thread = coroutine.running()
                                                                                                                        local finished = false

                                                                                                                        if elysianexecute then
                                                                                                                            local s,e = decompile(scr,function(src,err)
                                                                                                                            if not finished then
                                                                                                                                finished = true
                                                                                                                                coroutine.resume(thread,src,err)
                                                                                                                                end
                                                                                                                                end,saveSettings.DecompileTimeout)

                                                                                                                            if not s then return nil, e end
                                                                                                                                else
                                                                                                                                    return decompile(scr,nil,saveSettings.DecompileTimeout)
                                                                                                                                    end

                                                                                                                                    -- extra measures because windows sucks
                                                                                                                                    spawn(function()
                                                                                                                                    wait(saveSettings.DecompileTimeout + 1)
                                                                                                                                    if not finished then
                                                                                                                                        finished = true
                                                                                                                                        coroutine.resume(thread, nil, "decompile failed: decompiler timed out")
                                                                                                                                        end
                                                                                                                                        end)

                                                                                                                                    return coroutine.yield()
                                                                                                                                    end

                                                                                                                                    local function createStatusText()
                                                                                                                                    local statusText
                                                                                                                                    local pendingText = nil
                                                                                                                                    local dirty = false
                                                                                                                                    local conn
                                                                                                                                    local runService = service.RunService
                                                                                                                                    local startTime = tick()
                                                                                                                                    if syn or elysianexecute then
                                                                                                                                        statusText = Drawing.new("Text")
                                                                                                                                        statusText.Color = Color3.new(1,1,1)
                                                                                                                                        statusText.Outline = true
                                                                                                                                        statusText.OutlineColor = Color3.new(0,0,0)
                                                                                                                                        statusText[syn and "Size" or "FontSize"] = 50
                                                                                                                                        if syn then statusText.Visible = true end

                                                                                                                                            -- Buffer updates and apply them on the main thread to avoid parallel writes
                                                                                                                                            local function applyPending()
                                                                                                                                            if not pendingText then
                                                                                                                                                statusText.Text = ""
                                                                                                                                                else
                                                                                                                                                    -- Add elapsed time to status
                                                                                                                                                    local elapsed = tick() - startTime
                                                                                                                                                    local timeStr = string.format("%.1fs", elapsed)
                                                                                                                                                    statusText.Text = pendingText .. " [" .. timeStr .. "]"
                                                                                                                                                    end
                                                                                                                                                    local viewport = workspace.CurrentCamera.ViewportSize
                                                                                                                                                    statusText.Position = Vector2.new(viewport.X / 2 - statusText.TextBounds.X / 2, 50)
                                                                                                                                                    pendingText = nil
                                                                                                                                                    dirty = false
                                                                                                                                                    end

                                                                                                                                                    -- Connect a single heartbeat callback to perform actual UI writes
                                                                                                                                                    conn = runService.Heartbeat:Connect(function()
                                                                                                                                                    if dirty then
                                                                                                                                                        applyPending()
                                                                                                                                                        end
                                                                                                                                                        end)
                                                                                                                                                    else
                                                                                                                                                        return nil
                                                                                                                                                        end

                                                                                                                                                        local function updateStatus(text)
                                                                                                                                                        pendingText = text or ""
                                                                                                                                                        dirty = true
                                                                                                                                                        end

                                                                                                                                                        local function removeStatus()
                                                                                                                                                        if conn then conn:Disconnect() end
                                                                                                                                                            statusText:Remove()
                                                                                                                                                            end

                            return {Update = updateStatus, Remove = removeStatus}
                            end

                            local function predecompile(root,statusText,saveSettings)
                                                                                                                                                            if not saveSettings.Decompile then return {} end

                                                                                                                                                                local scripts,sources,checked = {},{},{}
                                                                                                                                                                local ignoredServices
                                                                                                                                                                local scriptCount,totalScripts = 1,0

                                                                                                                                                                if root == game and saveSettings.DecompileIgnore then
                                                                                                                                                                    ignoredServices = {}
                                                                                                                                                                    for i,v in pairs(saveSettings.DecompileIgnore) do
                                                                                                                                                                        ignoredServices[i] = game:GetService(v)
                                                                                                                                                                        end
                                                                                                                                                                        end

                                                                                                                                                                        local isTable = type(root) == "table"
                                                                                                                                                                        local objs = isTable and root or {root}
                                                                                                                                                                        local maxThreads = saveSettings.MaxThreads or 3
                                                                                                                                                                        local isDescendantOf = game.IsDescendantOf

                                                                                                                                                                        if saveSettings.NilInstances and root == game and getnilinstances then
                                                                                                                                                                            local nilInsts = getnilinstances()
                                                                                                                                                                            table.move(nilInsts,1,#nilInsts,#objs+1,objs)
                                                                                                                                                                            end

                                                                                                                                                                            for i = 1,#objs do
                                                                                                                                                                                local nextRoot = objs[i]
                                                                                                                                                                                local descs = nextRoot:GetDescendants()
                                                                                                                                                                                descs[0] = nextRoot
                                                                                                                                                                                for i = 0,#descs do
                                                                                                                                                                                    local obj = descs[i]
                                                                                                                                                                                    if (isa(obj,"LocalScript") or isa(obj,"ModuleScript") or isa(obj,"Script")) and not checked[obj] then
                                                                                                                                                                                        local ignored = false
                                                                                                                                                                                        if ignoredServices then
                                                                                                                                                                                            for i = 1,#ignoredServices do
                                                                                                                                                                                                if isDescendantOf(obj,ignoredServices[i]) then
                                                                                                                                                                                                    ignored = true
                                                                                                                                                                                                    break
                                                                                                                                                                                                    end
                                                                                                                                                                                                    end
                                                                                                                                                                                                    end

                                                                                                                                                                                                    if not ignored then
                                                                                                                                                                                                        scripts[scriptCount] = obj
                                                                                                                                                                                                        scriptCount = scriptCount + 1
                                                                                                                                                                                                        end

                                                                                                                                                                                                        checked[obj] = true
                                                                                                                                                                                                        end
                                                                                                                                                                                                        end
                                                                                                                                                                                                        end
                                                                                                                                                                                                        totalScripts = scriptCount - 1

                                                                                                                                                                                                        local left = totalScripts
                                                                                                                                                                                                        local lastConsolePercent = -1
                                                                                                                                                                                                        local function reportDecompileProgress()
                                                                                                                                                                                                            local completed = totalScripts - left
                                                                                                                                                                                                            local percent = totalScripts > 0 and math.floor((completed / totalScripts) * 100) or 100
                                                                                                                                                                                                            if percent ~= lastConsolePercent then
                                                                                                                                                                                                                lastConsolePercent = percent
                                                                                                                                                                                                                print(format("[DexSerializer] Decompilacao: %d%% (%d/%d)",percent,completed,totalScripts))
                                                                                                                                                                                                            end
                                                                                                                                                                                                            return percent
                                                                                                                                                                                                        end
                                                                                                                                                                                                        reportDecompileProgress()
                                                                                                                                                                                                        for i = 1,maxThreads do
                                                                                                                                                                                                            spawn(function()
                                                                                                                                                                                                            while true do
                                                                                                                                                                                                                local nextScript = table.remove(scripts)
                                                                                                                                                                                                                if not nextScript then break end
                                                                                                                                                                                                                    local scriptName
                                                                                                                                                                                                                    pcall(function() scriptName = nextScript:GetFullName() end)
                                                                                                                                                                                                                    if statusText then
                                                                                                                                                                                                                        statusText.Update("Decompiling " .. (scriptName or "<unknown>") .. " (" .. (totalScripts - left + 1) .. "/" .. totalScripts .. ")")
                                                                                                                                                                                                                        end
                                                                                                                                                                                                                        local ok, res = pcall(function() return doDecompile(nextScript, saveSettings) end)
                                                                                                                                                                                                                        local source, err
                                                                                                                                                                                                                        if ok then
                                                                                                                                                                                                                            source = res
                                                                                                                                                                                                                            else
                                                                                                                                                                                                                                source = nil
                                                                                                                                                                                                                                err = res
                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                if source then
                                                                                                                                                                                                                                    sources[nextScript] = source
                                                                                                                                                                                                                                    else
                                                                                                                                                                                                                                        sources[nextScript] = "-- This script could not be decompiled because:\n-- "..(err or "N/A")
                                                                                                                                                                                                                                        end

                                                                                                                                                                                                                                        left = left - 1
                                                                                                                                                                                                                                        local percent = reportDecompileProgress()
                                                                                                                                                                                                                                        if statusText then
                                                                                                                                                                                                                                            statusText.Update("Decompiling scripts... " .. percent .. "% (" .. (totalScripts - left) .. "/" .. totalScripts .. ")")
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            end)
                                                                                                                                                                                                            end

                                                                                                                                                                                                            -- Safety watchdog to avoid hanging forever
                                                                                                                                                                                                            local decompTimeout = saveSettings.DecompileTimeout or DefaultSettings.Serializer.DecompileTimeout or 10
                                                                                                                                                                                                            local maxWait = tick() + math.max(60, (decompTimeout * math.max(1, totalScripts)) / math.max(1, maxThreads) * 4)
                                                                                                                                                                                                                        while left > 0 do
                                                                                                                                                                                                                if tick() > maxWait then
                                                                                                                                                                                                                    if statusText then statusText.Update("Decompilation timed out; aborting remaining scripts") end
                                                                                                                                                                                                                        break
                                                                                                                                                                                                                        end
                                                                                                                                                                                                                        wait()
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        print("[DexSerializer] Decompilacao encerrada; iniciando serializacao")
                                                                                                                                                                                                                        return sources
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        local function serializeBinary(root,filename,saveSettings)
                                                                                                                                                                                                                        local mainBuf = {}

                                                                                                                                                                                                                        local header = {"\60\114\111\98\108\111\120\33\137\255\13\10\26\10\0\0","","","\0\0\0\0\0\0\0\0"}
                                                                                                                                                                                                                        local metaBuf = {"\77\69\84\65\36\0\0\0\34\0\0\0\0\0\0\0\240\19\1\0\0\0\18\0\0\0\69\120\112\108\105\99\105\116\65\117\116\111\74\111\105\110\116\115\4\0\0\0\116\114\117\101"}
                                                                                                                                                                                                                        local sstrBuf = {}
                                                                                                                                                                                                                        local instBuf,instBufCount = {},1
                                                                                                                                                                                                                        local propBuf,propBufCount = {},1
                                                                                                                                                                                                                        local prntBuf = {}
                                                                                                                                                                                                                        local endBuf = {"\69\78\68\0\0\0\0\0\9\0\0\0\0\0\0\0\60\47\114\111\98\108\111\120\62"}

                                                                                                                                                                                                                        local instTypeCount = 0
                                                                                                                                                                                                                        local instCount = 0
                                                                                                                                                                                                                        local refCount = 0
                                                                                                                                                                                                                        local sharedStringCount = 0

                                                                                                                                                                                                                        local isGame = root == game
                                                                                                                                                                                                                        local isTable = type(root) == "table"

                                                                                                                                                                                                                        local startB = tick()
                                                                                                                                                                                                                        local classList = {}
                                                                                                                                                                                                                        local hashs = {}
                                                                                                                                                                                                                        local sharedStrings = {}
                                                                                                                                                                                                                        local filter = {}
local refs = {}
local parents = {}
local orderedInstList = {}
local unionObjects = {}
local unionsWithPayload = {}
local unionReadFailureKeys = {}
local unionReadFailures = 0
local unionTotal = 0
local nilBlacklist = {[game] = true}
                                                                                                                                                                                                                        local folderClasses = {["Player"] = true, ["PlayerScripts"] = true, ["PlayerGui"] = true, ["ScriptDebugger"] = true, ["Breakpoints"] = true, ["DebuggerWatch"] = true}
                                                                                                                                                                                                                        local savingDefaultProps = not saveSettings.IgnoreDefaultProps
local decompileEnabled = saveSettings.Decompile

local unionPayloadProperties = {
ChildData = true,
ChildData2 = true,
MeshData = true,
MeshData2 = true,
PhysicsData = true,
PhysicalConfigData = true,
SolidMeshHolder = true,
}

local function recordUnionRead(obj,propName,ok,value)
if not unionObjects[obj] then return end
if not ok then
if optionalUnionProperties[propName] then return end
local failures = unionReadFailureKeys[obj]
if not failures then
failures = {}
unionReadFailureKeys[obj] = failures
end
if not failures[propName] then
failures[propName] = true
unionReadFailures = unionReadFailures + 1
end
elseif unionPayloadProperties[propName] and value ~= nil and value ~= "" then
unionsWithPayload[obj] = true
end
end

local function hiddenFallback(typeData)
local valueType = typeData.Name
if valueType == "bool" then return false end
if valueType == "int" or valueType == "int64" or valueType == "float" or valueType == "double" then return 0 end
if valueType == "Vector3" then return Vector3.new(1,1,1) end
if typeData.Category == "Enum" then
local ok,items = pcall(function() return Enum[valueType]:GetEnumItems() end)
return ok and items[1] or nil
end
return ""
end

local function safeHiddenReader(propName,typeData,...)
local fallback = hiddenFallback(typeData)
local readers = {...}
local readerCount = select("#",...)
return function(obj,indexName)
local ok,value = tryPropertyReaders(obj,indexName,unpack(readers,1,readerCount))
if not ok then
recordUnionRead(obj,propName,false)
return fallback
end
value = normalizePropertyValue(value,typeData)
if value == nil then
recordUnionRead(obj,propName,false)
return fallback
end
recordUnionRead(obj,propName,true,value)
return value
end
end

                                                                                                                                                                                                                        if isTable and not root[1] then error("Empty Table") end

                                                                                                                                                                                                                            -- Set up filter
                                                                                                                                                                                                                            -- Apply player filters for full-place and list/selection roots.
                                                                                                                                                                                                                            -- Some saveinstance wrappers pass game:GetChildren() instead of game.
                                                                                                                                                                                                                                for i,v in pairs(service.Players:GetPlayers()) do
                                                                                                                                                                                                                                    if not saveSettings.SavePlayers then
                                                                                                                                                                                                                                        filter[v] = true
                                                                                                                                                                                                                                        end

                                                                                                                                                                                                                                        if saveSettings.RemovePlayerCharacters and v.Character then
                                                                                                                                                                                                                                            filter[v.Character] = true
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            end

                                                                                                                                                                                                                                            if saveSettings.IsolateStarterPlayer then
                                                                                                                                                                                                                                                folderClasses["StarterPlayer"] = true
                                                                                                                                                                                                                                                folderClasses["StarterCharacterScripts"] = true
                                                                                                                                                                                                                                                folderClasses["StarterPlayerScripts"] = true
                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                if not filename then
                                                                                                                                                                                                                                                    filename = isGame and "Place_"..game.PlaceId or "Place_"..game.PlaceId.."_Inst_"..(isTable and root[1] or root):GetDebugId()
                                                                                                                                                                                                                                                    end
                                                                                                                                                                                                                                                    if isGame then
                                                                                                                                                                                                                                                        filename = filename:match("%.rbxlx?$") and filename or filename..".rbxl"
                                                                                                                                                                                                                                                        else
                                                                                                                                                                                                                                                            filename = filename:match("%.rbxmx?$") and filename or filename..".rbxm"
                                                                                                                                                                                                                                                            end

                        local statusText = saveSettings.ShowStatus and createStatusText()
                        local sources = predecompile(root,statusText,saveSettings)

                                                                                                                                                                                                                                                                -- Count instances and instance types
                                                                                                                                                                                                                                                                local function recur(obj)
                                                                                                                                                                                                                                                                if filter[obj] then return end

                                                                                                                                local class = oldIndex and oldIndex(obj,"ClassName") or obj.ClassName
                                                                                                                                if not saveSettings.SavePlayers and class == "Player" then return end
                                                                                                                                if serviceBlacklist[class] then return end
                                                                                                                                if folderClasses[class] then
                                                                                                                                                                                                                                                                class = "Folder"
                                                                                                                                                                                                                                                                if not saveProps["Folder"] then saveProps["Folder"] = getSaveProps(Instance.new("Folder"),"Folder") end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                if not saveProps[class] then saveProps[class] = getSaveProps(obj,class) end

                                                                                                                                                                                                                                                                if not testInsts[class] then testInsts[class] = (not savingDefaultProps and getTestInst(class) or {}) end

                                                                                                                                                                                                                                                                local ch = getChildren(obj)
                                                                                                                                                                                                                                                                local szCh = #ch
                                                                                                                                                                                                                                                                if szCh > 0 then
                                                                                                                                                                                                                                                                for i = 1,szCh do
                                                                                                                                                                                                                                                                local chObj = ch[i]
                                                                                                                                                                                                                                                                parents[chObj] = obj
                                                                                                                                                                                                                                                                recur(chObj)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

if not refs[obj] then
if apiClassIsA(class,"PartOperation") then
unionObjects[obj] = true
unionTotal = unionTotal + 1
end
instCount = instCount + 1
                                                                                                                                                                                                                                                                orderedInstList[instCount] = obj

                                                                                                                                                                                                                                                                local cList = classList[class]
                                                                                                                                                                                                                                                                if not cList then
                                                                                                                                                                                                                                                                cList = {}
                                                                                                                                                                                                                                                                classList[class] = cList
                                                                                                                                                                                                                                                                instTypeCount = instTypeCount + 1
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                cList[#cList+1] = obj

                                                                                                                                                                                                                                                                refs[obj] = refCount
                                                                                                                                                                                                                                                                refCount = refCount + 1
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                if isGame then
                                                                                                                                                                                                                                                                local gameCh = getChildren(root)
                                                                                                                                                                                                                                                                for i = 1,#gameCh do
                                                                                                                                                                                                                                                                local obj = gameCh[i]
                                                                                                                                                                                                                                                                if not serviceBlacklist[obj.ClassName] then
                                                                                                                                                                                                                                                                recur(obj)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                local message = readMeStart

                                                                                                                                                                                                                                                                for i, v in next, saveSettings do
                                                                                                                                                                                                                                                                if type(v) == "table" then -- assume array
                                                                                                                                                                                                                                                                local strings = {}
                                                                                                                                                                                                                                                                for j, k in next, v do
                                                                                                                                                                                                                                                                strings[#strings+1] = type(k) == "string" and ("\"" .. tostring(k) .. "\"") or tostring(v)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                message = message .. "\t" .. tostring(i) .. " = { " .. table.concat(strings, ", ") .. " }\n"
                                                                                                                                                                                                                                                                elseif i ~= "_Recurse" then
                                                                                                                                                                                                                                                                message = message .. "\t" .. tostring(i) .. " = " .. tostring(v) .. "\n"
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                message = message .. "]]"

                                                                                                                                                                                                                                                                local readmeScript = Instance.new("Script")
                                                                                                                                                                                                                                                                readmeScript.Name = "README"
                                                                                                                                                                                                                                                                nilBlacklist[readmeScript] = true
                                                                                                                                                                                                                                                                sources[readmeScript] = message
                                                                                                                                                                                                                                                                recur(readmeScript)
                                                                                                                                                                                                                                                                elseif isTable then
                                                                                                                                                                                                                                                                for i = 1,#root do
                                                                                                                                                                                                                                                                recur(root[i])
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                 else
                                                                                                                                                                                                                                                                 recur(root)
                                                                                                                                                                                                                                                                 end

                                                                                                                                                                                                                                                                 -- Prevent huge serializations from exhausting memory
                                                                                                                                                                                                                                                                print(format("[DexSerializer] Instancias encontradas: %d (referencias: %d)",instCount,refCount))
                                                                                                                                                                                                                                                                if refCount and refCount > 200000 then
                                                                                                                                                                                                                                                                if statusText then statusText.Update("Place too large to serialize; aborting to prevent OOM") end
                                                                                                                                                                                                                                                                warn(format("[DexSerializer] Save cancelado: %d referencias excedem o limite de 200000",refCount))
                                                                                                                                                                                                                                                                return nil, "Place too large to serialize; select fewer instances or enable streaming"
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                -- Prevent huge serializations from exhausting memory
                                                                                                                                                                                                                                                                if instCount and instCount > 150000 then
                                                                                                                                                                                                                                                                if statusText then statusText.Update("Place too large to serialize; aborting to prevent OOM") end
                                                                                                                                                                                                                                                                warn(format("[DexSerializer] Save cancelado: %d instancias excedem o limite de 150000",instCount))
                                                                                                                                                                                                                                                                return nil, "Place too large to serialize; select fewer instances or enable streaming"
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                -- Nil Instances
                                                                                                                                                                                                                                                                if saveSettings.NilInstances and root == game and getnilinstances then
                                                                                                                                                                                                                                                                local nilFolder = Instance.new("Folder")
                                                                                                                                                                                                                                                                nilFolder.Name = "Nil Instances"
                                                                                                                                                                                                                                                                nilBlacklist[nilFolder] = true
                                                                                                                                                                                                                                                                recur(nilFolder)

                                                                                                                                                                                                                                                                local classes = API.Classes
                                                                                                                                                                                                                                                                local nilInsts = getnilinstances()
                                                                                                                                                                                                                                                                for i = 1,#nilInsts do
                                                                                                                                                                                                                                                                local obj = nilInsts[i]
                                                                                                                                                                                                                                                                local class = oldIndex and oldIndex(obj,"ClassName") or obj.ClassName
                                                                                                                                                                                                                                                                if classes[class] and not classes[class].Tags.Service and not classes[class].Tags.NotCreatable and not nilBlacklist[obj] then
                                                                                                                                                                                                                                                                local parentClass = nilClassParents[class]
                                                                                                                                                                                                                                                                if parentClass then
                                                                                                                                                                                                                                                                local parentObj = Instance.new(parentClass)
                                                                                                                                                                                                                                                                parentObj.Name = class.." Class"
                                                                                                                                                                                                                                                                recur(parentObj)
                                                                                                                                                                                                                                                                parents[parentObj] = nilFolder

                                                                                                                                                                                                                                                                recur(obj)
                                                                                                                                                                                                                                                                parents[obj] = parentObj
                                                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                                                local isNilSafe = nilSafe[class]
                                                                                                                                                                                                                                                                if isNilSafe == nil then
                                                                                                                                                                                                                                                                isNilSafe = true
                                                                                                                                                                                                                                                                local folder = Instance.new("Folder")
                                                                                                                                                                                                                                                                local s,inst = pcall(Instance.new,class)
                                                                                                                                                                                                                                                                if s and not pcall(function() inst.Parent = folder end) then
                                                                                                                                                                                                                                                                isNilSafe = false
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                nilSafe[class] = isNilSafe
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                if isNilSafe then
                                                                                                                                                                                                                                                                recur(obj)
                                                                                                                                                                                                                                                                parents[obj] = nilFolder
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                -- Special Handlers
local refPropHandler = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(4*szObjs)
                                                                                                                                                                                                                                                                local sep = szObjs-1

                                                                                                                                                                                                                                                                local lastRef
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local start = i-1
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if func then val = func(objs[i],name) elseif oldIndex then val = oldIndex(objs[i],name) else val = objs[i][name] end
                                                                                                                                                                                                                                                                local ref = refs[val] or -1
                                                                                                                                                                                                                                                                local accRef

                                                                                                                                                                                                                                                                -- Accumulation
                                                                                                                                                                                                                                                                accRef = lastRef and (ref - lastRef) or ref
                                                                                                                                                                                                                                                                lastRef = ref

                                                                                                                                                                                                                                                                local transformed = (accRef < 0 and 2 * -accRef - 1 or 2 * accRef)
                                                                                                                                                                                                                                                                local bytes = s_pack(">I4",transformed)

                                                                                                                                                                                                                                                                for b = 1,4 do
                                                                                                                                                                                                                                                                result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
return concat(result)
end

local function encodeInterleavedInts(values,useDelta)
local valueCount = #values
local result = tableCreate(4*valueCount)
local sep = valueCount-1
local previous
for i = 1,valueCount do
local value = values[i]
if useDelta then
local current = value
value = previous and (current-previous) or current
previous = current
end
local transformed = value < 0 and 2 * -value - 1 or 2 * value
local bytes = s_pack(">I4",transformed)
local start = i-1
for b = 1,4 do
result[start+b+sep*(b-1)] = sub(bytes,b,b)
end
end
return concat(result)
end

local contentPropHandler = function(objs,name,func)
local sourceTypes,uris,objectRefs = {},{},{}
for i = 1,#objs do
local ok,value = pcall(function()
if func then return func(objs[i],name) end
if oldIndex then return oldIndex(objs[i],name) end
return objs[i][name]
end)
local sourceType,payload = readContentValue(ok and value or nil)
sourceTypes[i] = sourceType
if sourceType == 1 then
uris[#uris+1] = payload or ""
elseif sourceType == 2 then
objectRefs[#objectRefs+1] = refs[payload] or -1
end
end

local uriData = {s_pack("<I4",#uris)}
for i = 1,#uris do
local uri = uris[i]
uriData[#uriData+1] = s_pack("<I4",#uri)..uri
end

return encodeInterleavedInts(sourceTypes,false)
..concat(uriData)
..s_pack("<I4",#objectRefs)
..encodeInterleavedInts(objectRefs,true)
..s_pack("<I4",0)
end

local sharedStringHandler = function(objs,name,func)
                                                                                                                                                                                                                                                                if not gethiddenprop then return end

                                                                                                                                                                                                                                                                if sharedStringCount == 0 then
                                                                                                                                                                                                                                                                sharedStringCount = sharedStringCount + 1
                                                                                                                                                                                                                                                                sharedStrings[1] = {"NullSharedString",""}
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(4*szObjs,"\0")
                                                                                                                                                                                                                                                                local sep = szObjs-1
for i = 1,szObjs do
local start = i-1
local content
if func then
content = func(objs[i],name)
else
local ok,value = pcall(gethiddenprop,objs[i],name)
content = ok and value or nil
end
if content and #content > 0 then
                                                                                                                                                                                                                                                                local hash = content
                                                                                                                                                                                                                                                                local index = hashs[hash]
                                                                                                                                                                                                                                                                if not index then
                                                                                                                                                                                                                                                                index = sharedStringCount
                                                                                                                                                                                                                                                                hashs[hash] = index
                                                                                                                                                                                                                                                                sharedStringCount = sharedStringCount + 1
sharedStrings[sharedStringCount] = {makeSharedStringIdentifier(sharedStringCount),content}
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                local bytes = s_pack(">I4", index)
                                                                                                                                                                                                                                                                for b = 1,4 do
                                                                                                                                                                                                                                                                result[start + b + sep*(b-1)] = sub(bytes,b,b)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                local protectedStringHandler = function(objs,name,func)
                                                                                                                                                                                                                                                                local szObjs = #objs
                                                                                                                                                                                                                                                                local result = tableCreate(szObjs)
                                                                                                                                                                                                                                                                for i = 1,szObjs do
                                                                                                                                                                                                                                                                local val
                                                                                                                                                                                                                                                                if sources[objs[i]] then
                                                                                                                                                                                                                                                                val = sources[objs[i]]
                                                                                                                                                                                                                                                                elseif not decompileEnabled then
                                                                                                                                                                                                                                                                val = "-- Decompiling is disabled"
                                                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                                                val = "-- Script failed to decompile or ignored"
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                result[i] = s_pack("<I4",#val)..val
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                return concat(result)
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                local typeId = 0
                                                                                                                                                                                                                                                                for class,objs in next,classList do
                                                                                                                                                                                                                                                                -- Make INST chunk
                                                                                                                                                                                                                                                                local instHeader = {"INST","\0\0\0\0","","\0\0\0\0"}
                                                                                                                                                                                                                                                                local instChunkData = tableCreate(4 + 4*#objs,"")
                                                                                                                                                                                                                                                                local typeIdBytes = s_pack("<I4",typeId)
                                                                                                                                                                                                                                                                local isService = API.Classes[class] and API.Classes[class].Tags.Service
                                                                                                                                                                                                                                                                instChunkData[1] = typeIdBytes
                                                                                                                                                                                                                                                                instChunkData[2] = s_pack("<I4",#class)..class
                                                                                                                                                                                                                                                                instChunkData[3] = isService and "\1" or "\0"
                                                                                                                                                                                                                                                                instChunkData[4] = s_pack("<I4",#objs)

                                                                                                                                                                                                                                                                local lastRef
                                                                                                                                                                                                                                                                local sep = #objs-1
                                                                                                                                                                                                                                                                for i = 1,#objs do
                                                                                                                                                                                                                                                                local start = 4 + (i-1)
                                                                                                                                                                                                                                                                local obj = objs[i]
                                                                                                                                                                                                                                                                local ref = refs[obj]
                                                                                                                                                                                                                                                                local accRef

                                                                                                                                                                                                                                                                -- Accumulation
                                                                                                                                                                                                                                                                accRef = lastRef and (ref - lastRef) or ref
                                                                                                                                                                                                                                                                lastRef = ref

                                                                                                                                                                                                                                                                local transformed = (accRef < 0 and 2 * -accRef - 1 or 2 * accRef)
                                                                                                                                                                                                                                                                local bytes = s_pack(">I4",transformed)

                                                                                                                                                                                                                                                                for b = 1,4 do
                                                                                                                                                                                                                                                                local chunkIndex = start + b + sep*(b-1)
                                                                                                                                                                                                                                                                instChunkData[chunkIndex] = sub(bytes,b,b)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                if isService then
                                                                                                                                                                                                                                                                instChunkData[#instChunkData+1] = s_rep("\1",#objs)
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                instChunkData = concat(instChunkData)
                                                                                                                                                                                                                                                                instHeader[3] = s_pack("<I4",#instChunkData)

                                                                                                                                                                                                                                                                if lz4compress then
                                                                                                                                                                                                                                                                instChunkData = lz4compress(instChunkData)
                                                                                                                                                                                                                                                                instHeader[2] = s_pack("<I4",#instChunkData)
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                instBuf[instBufCount] = concat(instHeader)
                                                                                                                                                                                                                                                                instBuf[instBufCount+1] = instChunkData
                                                                                                                                                                                                                                                                instBufCount = instBufCount + 2


                                                                                                                                                                                                                                                                -- Make PROP chunk
                                                                                                                                                                                                                                                                local props = saveProps[class]
                                                                                                                                                                                                                                                                for propInd = 1,#props do
                                                                                                                                                                                                                                                                local prop = props[propInd]
                                                                                                                                                                                                                                                                local propName = prop.Name
                                                                                                                                                                                                                                                                local indexName = prop.IndexName or propName
                                                                                                                                                                                                                                                                local typeData = prop.ValueType
                                                                                                                                                                                                                                                                local propTypeCategory = typeData.Category
                                                                                                                                                                                                                                                                local propType = typeData.Name

                                                                                                                                                                                                                                                                local propHeader = {"PROP","\0\0\0\0","","\0\0\0\0"}
                                                                                                                                                                                                                                                                local propChunkData = {typeIdBytes, s_pack("<I4",#propName)..propName, nil, ""}

                                                                                                                                                                                                                                                                local handler
                                                                                                                                                                                                                                                                if propTypeCategory == "Primitive" or propTypeCategory == "DataType" then
                                                                                                                                                                                                                                                                handler = binaryPropHandlers[propType]
                                                                                                                                                                                                                                                                propChunkData[3] = binaryDataTypes[propType]

if not handler then
if propType == "Content" then
handler = contentPropHandler
elseif propType == "SharedString" or propType == "NetAssetRef" then
handler = sharedStringHandler
                                                                                                                                                                                                                                                                elseif propType == "ProtectedString" then
                                                                                                                                                                                                                                                                handler = protectedStringHandler
                                                                                                                                                                                                                                                                propChunkData[3] = binaryDataTypes.string
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                elseif propTypeCategory == "Enum" then
                                                                                                                                                                                                                                                                handler = binaryPropHandlers.Enum
                                                                                                                                                                                                                                                                propChunkData[3] = binaryDataTypes.Enum
                                                                                                                                                                                                                                                                else -- Assume Class
                                                                                                                                                                                                                                                                handler = refPropHandler
                                                                                                                                                                                                                                                                propChunkData[3] = binaryDataTypes.Referent
                                                                                                                                                                                                                                                                end

if handler then
local func
local special = prop.Special

if special == "BinaryString" then
func = safeHiddenReader(propName,typeData,getbspval,gethiddenprop,getnspval)
elseif special == "SharedString" then
func = safeHiddenReader(propName,typeData,gethiddenprop,getbspval,getnspval)
elseif special == "NotScriptable" or (prop.Tags and prop.Tags.NotScriptable) then
func = safeHiddenReader(propName,typeData,getnspval,gethiddenprop)
elseif special == "Func" then
func = prop.Func
end

local propOk,propData = pcall(handler,objs,indexName,func)
if not propOk or not propData then
for i = 1,#objs do
recordUnionRead(objs[i],propName,false)
end
continue
end
propChunkData[4] = propData

                                                                                propChunkData = concat(propChunkData)
                                                                                propHeader[3] = s_pack("<I4",#propChunkData)

                                                                                if lz4compress then
                                                                                    propChunkData = lz4compress(propChunkData)
                                                                                    propHeader[2] = s_pack("<I4",#propChunkData)
                                                                                    end

                                                                                    propBuf[propBufCount] = concat(propHeader)
                                                                                    propBuf[propBufCount+1] = propChunkData
                                                                                    propBufCount = propBufCount + 2
                                                                                    end
                                                                                    end

                                                                                     typeId = typeId + 1
                                                                                     end


                                                                                     -- Make SSTR chunk
                                                                                    if sharedStringCount > 0 then
                                                                                        local sstrHeader = {"SSTR","\0\0\0\0","","\0\0\0\0"}
                                                                                        local sstrChunkData = {"\0\0\0\0",s_pack("<I4",sharedStringCount)}
                                                                                        local count = 3

                                                                                        for i = 1,#sharedStrings do
                                                                                            local data = sharedStrings[i]
                                                                                            local hash,content = data[1],data[2]
                                                                                            sstrChunkData[count] = hash..s_pack("<I4",#content)..content
                                                                                            count = count + 1
                                                                                            end

                                                                                            sstrChunkData = concat(sstrChunkData)
                                                                                            sstrHeader[3] = s_pack("<I4",#sstrChunkData)

                                                                                            if lz4compress then
                                                                                                sstrChunkData = lz4compress(sstrChunkData)
                                                                                                sstrHeader[2] = s_pack("<I4",#sstrChunkData)
                                                                                                end

                                                                                                sstrBuf[1] = concat(sstrHeader)
                                                                                                sstrBuf[2] = sstrChunkData
                                                                                                end


                                                                                                -- Make PRNT chunk
                                                                                                local function makePRNT()
                                                                                                local prntHeader = {"PRNT","\0\0\0\0","","\0\0\0\0"}
                                                                                                local prntChunkData = tableCreate(2 + 2*4*instCount)
                                                                                                prntChunkData[1] = "\0"
                                                                                                prntChunkData[2] = s_pack("<I4",instCount)

                                                                                                local lastObjRef,lastParRef
                                                                                                local sep = instCount-1
                                                                                                local prntRefCount = 1
                                                                                                local lastObjIndex = 2 + 4*instCount
                                                                                                for i = 1,instCount do
                                                                                                    local obj = orderedInstList[i]
                                                                                                    local ref = refs[obj]

                                                                                                    local objStart = 2 + (prntRefCount-1)
                                                                                                    local parStart = lastObjIndex + (prntRefCount-1)

                                                                                                    local par = parents[obj]
                                                                                                    local parRef = refs[par] or -1

                                                                                                    local accObjRef
                                                                                                    local accParRef

                                                                                                    -- Accumulation
                                                                                                    accObjRef = lastObjRef and (ref - lastObjRef) or ref
                                                                                                    lastObjRef = ref

                                                                                                    accParRef = lastParRef and (parRef - lastParRef) or parRef
                                                                                                    lastParRef = parRef

                                                                                                    -- Interleave obj and parent bytes
                                                                                                    local objTransformed = (accObjRef < 0 and 2 * -accObjRef - 1 or 2 * accObjRef)
                                                                                                    local objBytes = s_pack(">I4",objTransformed)
                                                                                                    local parTransformed = (accParRef < 0 and 2 * -accParRef - 1 or 2 * accParRef)
                                                                                                    local parBytes = s_pack(">I4",parTransformed)

                                                                                                    for b = 1,4 do
                                                                                                        local objChunkIndex = objStart + b + sep*(b-1)
                                                                                                        local parChunkIndex = parStart + b + sep*(b-1)
                                                                                                        prntChunkData[objChunkIndex] = sub(objBytes,b,b)
                                                                                                        prntChunkData[parChunkIndex] = sub(parBytes,b,b)
                                                                                                        end

                                                                                                        prntRefCount = prntRefCount + 1
                                                                                                        end

                                                                                                        prntChunkData = concat(prntChunkData)
                                                                                                        prntHeader[3] = s_pack("<I4",#prntChunkData)

                                                                                                        if lz4compress then
                                                                                                            prntChunkData = lz4compress(prntChunkData)
                                                                                                            prntHeader[2] = s_pack("<I4",#prntChunkData)
                                                                                                            end

                                                                                                            prntBuf[1] = concat(prntHeader)
                                                                                                            prntBuf[2] = prntChunkData
                                                                                                            end
                                                                                                             makePRNT()


                                                                                                             -- Wrap up
header[2] = s_pack("<i4",instTypeCount)
header[3] = s_pack("<i4",instCount)

local unionsWithPayloadCount = 0
for _ in pairs(unionsWithPayload) do
unionsWithPayloadCount = unionsWithPayloadCount + 1
end
local unionFailureDetails = formatUnionFailures(unionReadFailureKeys)
local unionSummary = format(" | CSG: %d/%d unions with local payload, %d hidden read failures",unionsWithPayloadCount,unionTotal,unionReadFailures)
if unionFailureDetails ~= "" then unionSummary = unionSummary.." ["..unionFailureDetails.."]" end
if unionTotal > 0 and not statusText then
pcall(warn,"DexSerializer"..unionSummary)
end

if not saveSettings.Clipboard and not saveSettings.Callback then
                                                                                                                print("[DexSerializer] Serializacao concluida; gravando arquivo")
                                                                                                                -- Only create/truncate the file after serialization succeeded.
                                                                                                                env.writefile(filename,concat(header))
                                                                                                                env.appendfile(filename,concat(metaBuf),true)
                                                                                                                env.appendfile(filename,concat(sstrBuf),true)
                                                                                                                env.appendfile(filename,concat(instBuf),true)
                                                                                                                env.appendfile(filename,concat(propBuf),true)
                                                                                                                env.appendfile(filename,concat(prntBuf),true)
                                                                                                                env.appendfile(filename,concat(endBuf),true)
                                                                                                                print("[DexSerializer] Arquivo gravado: "..filename)

if statusText then
statusText.Update("Saved to the file "..filename.." in "..(tick()-startB).." secs"..unionSummary)
                                                                                                                     delay(5,statusText.Remove)
                                                                                                                     end
                                                                                                                    else
                                                                                                                        local totalData = {concat(header), concat(metaBuf), concat(sstrBuf), concat(instBuf), concat(propBuf), concat(prntBuf), concat(endBuf)}
                                                                                                                        totalData = concat(totalData)

                                                                                                                        if saveSettings.Clipboard then
                                                                                                                            if setrbxclipboard then
                                                                                                                                setrbxclipboard(totalData)
                                                                                                                                end
                                                                                                                                elseif saveSettings.Callback and type(saveSettings.Callback) == "function" then
                                                                                                                                    task.spawn(saveSettings.Callback,totalData)
                                                                                                                                    end
                                                                                                                                    end
                                                                                                                                    return true,statusText
                                                                                                                                    end

                                                                                                                                    local function serializeXML(root,filename,saveSettings)
                                                                                                                                    local isGame = root == game
                                                                                                                                    local isTable = type(root) == "table"
                                                                                                                                    if isTable and not root[1] then error("Empty Table") end

                                                                                                                                        if not filename then
                                                                                                                                            filename = isGame and "Place_"..game.PlaceId or "Place_"..game.PlaceId.."_Inst_"..(isTable and root[1] or root):GetDebugId()
                                                                                                                                            end
                                                                                                                                            if isGame then
                                                                                                                                                filename = filename:match("%.rbxlx?$") and filename or filename..".rbxlx"
                                                                                                                                                else
                                                                                                                                                    filename = filename:match("%.rbxmx?$") and filename or filename..".rbxmx"
                                                                                                                                                    end
                                                                                                                                                    env.writefile(filename,"")

                                                                                                                                                    local startB = tick()
                                                                                                                                                    local folderClasses = {["Player"] = true, ["PlayerScripts"] = true, ["PlayerGui"] = true, ["ScriptDebugger"] = true, ["Breakpoints"] = true, ["DebuggerWatch"] = true}
                                                                                                                                                    local insts = {}
                                                                                                                                                    local refs = {}
                                                                                                                                                    local refCount = 1
local depths = {}
local filter = {}
local hashs = {}
local sharedStrings = {}
local unionObjects = {}
local unionsWithPayload = {}
local unionReadFailureKeys = {}
local unionReadFailures = 0
local unionTotal = 0
local sharedStringIdentifier = 1
local savingDefaultProps = not saveSettings.IgnoreDefaultProps
                                                                                                                                                    local decompileEnabled = saveSettings.Decompile
                                                                                                                                                     local statusText = saveSettings.ShowStatus and createStatusText()
local sources = predecompile(root,statusText,saveSettings)

local unionPayloadProperties = {
ChildData = true,
ChildData2 = true,
MeshData = true,
MeshData2 = true,
PhysicsData = true,
PhysicalConfigData = true,
SolidMeshHolder = true,
}

local function recordUnionRead(obj,propName,ok,value)
if not unionObjects[obj] then return end
if not ok then
if optionalUnionProperties[propName] then return end
local failures = unionReadFailureKeys[obj]
if not failures then
failures = {}
unionReadFailureKeys[obj] = failures
end
if not failures[propName] then
failures[propName] = true
unionReadFailures = unionReadFailures + 1
end
elseif unionPayloadProperties[propName] and value ~= nil and value ~= "" then
unionsWithPayload[obj] = true
end
end

local function readHidden(obj,propName,...)
local ok,value = tryPropertyReaders(obj,propName,...)
if not ok then
recordUnionRead(obj,propName,false)
return false,nil
end
recordUnionRead(obj,propName,true,value)
return true,value
end

local function getSharedStringKey(content)
local cached = hashs[content]
if cached then return cached end

local key
if hashmd5 then
local ok,rawHash = pcall(hashmd5,content)
if ok and type(rawHash) == "string" and #rawHash >= 32 and rawHash:sub(1,32):match("^%x+$") then
local bytes = {}
for i = 1,32,2 do
bytes[#bytes+1] = string.char(tonumber(rawHash:sub(i,i+1),16))
end
key = encodeBase64(concat(bytes))
end
end
if not key then
key = encodeBase64(makeSharedStringIdentifier(sharedStringIdentifier))
sharedStringIdentifier = sharedStringIdentifier + 1
end

hashs[content] = key
return key
end

                                                                                                                                                    -- Set up filter
                                                                                                                                                    -- Apply player filters for full-place and list/selection roots.
                                                                                                                                                    -- Some saveinstance wrappers pass game:GetChildren() instead of game.
                                                                                                                                                        for i,v in pairs(service.Players:GetPlayers()) do
                                                                                                                                                            if not saveSettings.SavePlayers then
                                                                                                                                                                filter[v] = true
                                                                                                                                                                end

                                                                                                                                                                if saveSettings.RemovePlayerCharacters and v.Character then
                                                                                                                                                                    filter[v.Character] = true
                                                                                                                                                                    end
                                                                                                                                                                    end

                                                                                                                                                                    if saveSettings.IsolateStarterPlayer then
                                                                                                                                                                        folderClasses["StarterPlayer"] = true
                                                                                                                                                                        folderClasses["StarterCharacterScripts"] = true
                                                                                                                                                                        folderClasses["StarterPlayerScripts"] = true
                                                                                                                                                                        end

                                                                                                                                                                         local buffer = {'<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">\n<Meta name="ExplicitAutoJoints">true</Meta>\n<External>null</External>\n<External>nil</External>'}
                                                                                                                                                                         local bufferCount = 2

                                                                                                                                                                         local function recur(obj)
                                                                                                                                                                        if filter[obj] then return end

                                                                                                                                                                            local class = oldIndex and oldIndex(obj,"ClassName") or obj.ClassName
                                                                                                                                                                            if not saveSettings.SavePlayers and class == "Player" then return end
                                                                                                                                                                            if serviceBlacklist[class] then return end
                                                                                                                                                                            if folderClasses[class] then
                                                                                                                                                                                class = "Folder"
                                                                                                                                                                                if not saveProps["Folder"] then saveProps["Folder"] = getSaveProps(Instance.new("Folder"),"Folder") end
                                                                                                                                                                                    end

local ref = refs[obj]
if not ref then
ref = refCount refs[obj] = ref refCount = refCount + 1
if apiClassIsA(class,"PartOperation") then
unionObjects[obj] = true
unionTotal = unionTotal + 1
end
end

                                                                                                                                                                                        local props = saveProps[class]
                                                                                                                                                                                        if not props then props = getSaveProps(obj,class) saveProps[class] = props end

                                                                                                                                                                                            local testInst = testInsts[class]
                                                                                                                                                                                            if not testInst then testInst = (not savingDefaultProps and getTestInst(class) or {}) testInsts[class] = testInst end

                                                                                                                                                                                                buffer[bufferCount] = format('\n<Item class="%s" referent="RBX%d">\n<Properties>',class,ref)
                                                                                                                                                                                                bufferCount = bufferCount + 1

                                                                                                                                                                                                for i = 1,#props do
                                                                                                                                                                                                    local prop = props[i]
                                                                                                                                                                                                    local propName = prop.Name
                                                                                                                                                                                                    local indexName = prop.IndexName or propName
local propVal

local special = prop.Special
local propReadOk = true
if special then
if special == "NotScriptable" then
propReadOk,propVal = readHidden(obj,propName,getnspval,gethiddenprop)
elseif special == "BinaryString" then
local rawValue
propReadOk,rawValue = readHidden(obj,propName,getbspval,gethiddenprop,getnspval)
if propReadOk then
rawValue = normalizePropertyValue(rawValue,prop.ValueType)
propReadOk,propVal = pcall(encodeBase64,rawValue)
if not propReadOk then recordUnionRead(obj,propName,false) end
end
elseif special == "SharedString" then
local content
propReadOk,content = readHidden(obj,propName,gethiddenprop,getbspval,getnspval)
if propReadOk then content = normalizePropertyValue(content,prop.ValueType) end
if content and #content > 0 then
local keyOk,hash = pcall(getSharedStringKey,content)
local contentOk,encodedContent = pcall(encodeBase64,content)
if keyOk and contentOk then
sharedStrings[hash] = sharedStrings[hash] or encodedContent
propVal = hash
else
propReadOk = false
recordUnionRead(obj,propName,false)
end
end
elseif special == "Func" then
propReadOk,propVal = pcall(prop.Func,obj)
if not propReadOk then recordUnionRead(obj,propName,false) end
elseif special == "Decompile" then
if sources[obj] then
propVal = sources[obj]
                                                                                                                                                                                                                                                elseif not decompileEnabled then
                                                                                                                                                                                                                                                    propVal = "-- Decompiling is disabled"
                                                                                                                                                                                                                                                    else
                                                                                                                                                                                                                                                        propVal = "-- Script failed to decompile or ignored"
                                                                                                                                                                                                                                                        end
end
else
propReadOk,propVal = pcall(function()
if oldIndex then return oldIndex(obj,indexName) end
return obj[indexName]
end)
if not propReadOk then recordUnionRead(obj,propName,false) end
end

if propReadOk then propVal = normalizePropertyValue(propVal,prop.ValueType) end
if not propReadOk then continue end

if testInst[indexName] ~= propVal or (savingDefaultProps and propVal ~= nil) then
                                                                                                                                                                                                                                                                local typeData = prop.ValueType
                                                                                                                                                                                                                                                                local propType = typeData.Name

                                                                                                                                                                                                                                                                local convertFunc = valueConverters[propType]
                                                                                                                                                                                                                                                                if convertFunc then
                                                                                                                                                                                                                                                                buffer[bufferCount] = convertFunc(propName,propVal)
                                                                                                                                                                                                                                                                elseif typeData.Category == "Enum" then
                                                                                                                                                                                                                                                                buffer[bufferCount] = format('\n<token name="%s">%d</token>',propName,propVal.Value)
                                                                                                                                                                                                                                                                elseif classes[propType] and propVal then
                                                                                                                                                                                                                                                                local ref = refs[propVal]
                                                                                                                                                                                                                                                                if not ref then ref = refCount refs[propVal] = ref refCount = refCount + 1 end
                                                                                                                                                                                                                                                                buffer[bufferCount] = format('\n<Ref name="%s">RBX%d</Ref>',propName,ref)
                                                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                                                buffer[bufferCount] = ""
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                bufferCount = bufferCount + 1
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                buffer[bufferCount] = '\n</Properties>'
                                                                    bufferCount = bufferCount + 1

                                                                    if bufferCount > 10000 then
                                                                        env.appendfile(filename,table.concat(buffer))
                                                                        table.clear(buffer)
                                                                        bufferCount = 1
                                                                        end

                                                                        local ch = getChildren(obj)
                                                                        local szCh = #ch
                                                                        if szCh > 0 then
                                                                            for i = 1,szCh do
                                                                                recur(ch[i])
                                                                                end
                                                                                end

                                                                                buffer[bufferCount] = '\n</Item>'
                                                                    bufferCount = bufferCount + 1
                                                                    end

                                                                    if isGame then
                                                                        local gameCh = getChildren(root)
                                                                        for i = 1,#gameCh do
                                                                            local obj = gameCh[i]
                                                                            if not serviceBlacklist[obj.ClassName] then
                                                                                recur(obj)
                                                                                end
                                                                                end

                                                                                local message = readMeStart

                                                                                for i, v in next, saveSettings do
                                                                                    if type(v) == "table" then -- assume array
                                                                                        local strings = {}
                                                                                        for j, k in next, v do
                                                                                            strings[#strings+1] = type(k) == "string" and ("\"" .. tostring(k) .. "\"") or tostring(v)
                                                                                            end
                                                                                            message = message .. "\t" .. tostring(i) .. " = { " .. table.concat(strings, ", ") .. " }\n"
                                                                                            elseif i ~= "_Recurse" then
                                                                                                message = message .. "\t" .. tostring(i) .. " = " .. tostring(v) .. "\n"
                                                                                                end

                                                                                                end

                                                                                                message = message .. "]]"

                                                                                                buffer[bufferCount] = [==[

                                                                                                    <Item class="Script" referent="RBX999999999">
                                                                                                    <Properties>
                                                                                                    <string name="Name">README</string>
                                                                                                    <ProtectedString name="Source">]==]..gsub(message, xmlReplacePattern, xmlReplace)..[==[</ProtectedString>
                                                                                                    </Properties>
                                                                                                    </Item>]==]
                                                                                                    bufferCount = bufferCount + 1
                                                                                                    elseif isTable then
                                                                                                        for i = 1,#root do
                                                                                                            recur(root[i])
                                                                                                            end
                                                                                                            else
                                                                                                                recur(root)
                                                                                                                end

                                                                                                                -- Nil Instances
                                                                                                                if saveSettings.NilInstances and root == game and getnilinstances then
                                                                                                                    local folderRef = refCount
                                                                                                                    refCount = refCount + 1
                                                                                                                    buffer[bufferCount] = '\n<Item class="Folder" referent="RBX'..folderRef..'">\n<Properties>\n<string name="Name">Nil Instances</string>\n</Properties>'
                                                                    bufferCount = bufferCount + 1

                                                                    local classes = API.Classes
                                                                    local nilInsts = getnilinstances()
                                                                    for i = 1,#nilInsts do
                                                                        local obj = nilInsts[i]
                                                                        local class = oldIndex and oldIndex(obj,"ClassName") or obj.ClassName
                                                                        if classes[class] and not classes[class].Tags.Service and not classes[class].Tags.NotCreatable and obj ~= game then
                                                                            local parentClass = nilClassParents[class]
                                                                            if parentClass then
                                                                                local parentRef = refCount
                                                                                refCount = refCount + 1
                                                                                buffer[bufferCount] = format('\n<Item class="%s" referent="RBX%d">\n<Properties>\n<string name="Name">%s Class</string>\n</Properties>',parentClass,parentRef,class)
                                                                                bufferCount = bufferCount + 1
                                                                                recur(obj)
                                                                                buffer[bufferCount] = "\n</Item>"
                                                                                bufferCount = bufferCount + 1
                                                                                else
                                                                                    local isNilSafe = nilSafe[class]
                                                                                    if isNilSafe == nil then
                                                                                        isNilSafe = true
                                                                                        local folder = Instance.new("Folder")
                                                                                        local s,inst = pcall(Instance.new,class)
                                                                                        if s and not pcall(function() inst.Parent = folder end) then
                                                                                            isNilSafe = false
                                                                                            end
                                                                                            nilSafe[class] = isNilSafe
                                                                                            end
                                                                                            if isNilSafe then recur(obj) end
                                                                                                end
                                                                                                end
                                                                                                end
                                                                                                buffer[bufferCount] = "\n</Item>"
                                                                                                bufferCount = bufferCount + 1
                                                                                                end

                                                                                                 -- SharedStrings
                                                                                                 buffer[bufferCount] = "\n<SharedStrings>"
                                                                                                bufferCount = bufferCount + 1
                                                                                                for hash,content in next,sharedStrings do
                                                                                                    buffer[bufferCount] = '\n<SharedString md5="'..hash..'">'..content..'</SharedString>'
                                                                    bufferCount = bufferCount + 1
                                                                    end

                                                                    buffer[bufferCount] = "\n</SharedStrings>\n</roblox>"
                                                                    env.appendfile(filename,table.concat(buffer))
table.clear(buffer)
table.clear(hashs)
table.clear(sharedStrings)

local unionsWithPayloadCount = 0
for _ in pairs(unionsWithPayload) do
unionsWithPayloadCount = unionsWithPayloadCount + 1
end
local unionFailureDetails = formatUnionFailures(unionReadFailureKeys)
local unionSummary = format(" | CSG: %d/%d unions with local payload, %d hidden read failures",unionsWithPayloadCount,unionTotal,unionReadFailures)
if unionFailureDetails ~= "" then unionSummary = unionSummary.." ["..unionFailureDetails.."]" end
if unionTotal > 0 and not statusText then
pcall(warn,"DexSerializer"..unionSummary)
end

if statusText then
statusText.Update("Saved to the file "..filename.." in "..(tick()-startB).." secs"..unionSummary)
delay(5,statusText.Remove)
end
return true,statusText
                                                                        end

                                                                        Serializer.SaveInstance = function(root,filename,opts)
                                                                        if not gameId then gameId = game.GameId end
                                                                            local saveSettings = {}
                                                                            for set,val in pairs(Settings.Serializer) do
                                                                                if opts and opts[set] ~= nil then
                                                                                    saveSettings[set] = opts[set]
                                                                                    else
                                                                                        saveSettings[set] = val
                                                                                        end
                                                                                        end
                                                                                        if saveSettings.DecompileMode and saveSettings.DecompileMode > 0 then saveSettings.Decompile = true end

                                                                                            -- Activate safety features
                                                                                            local antiIdleConn
                                                                                            if saveSettings.SafeMode then
                                                                                                activateSafeMode()
                                                                                                -- SafeMode also enables these protections
                                                                                                saveSettings.BoostFPS = true
                                                                                                saveSettings.KillAllScripts = true
                                                                                                end
                                                                                                if saveSettings.BoostFPS then boostFPS() end
                                                                                                    if saveSettings.AntiIdle then antiIdleConn = startAntiIdle() end
                                                                                                        if saveSettings.Anonymous then cleanAnonymousData(root, saveSettings) end

                                                                                                            -- Handle different modes
                                                                                                            local mode = (saveSettings.Mode or "full"):lower()
                                                                                                            if mode == "scripts" then
                                                                                                                saveSettings.Decompile = true
                                                                                                                saveSettings.NilInstances = false
                                                                                                                elseif mode == "models" then
                                                                                                                    saveSettings.Decompile = false
                                                                                                                    end

                                                                                                                    local callOk, ok, statusText
                                                                                                                    if saveSettings.Binary then
                                                                                                                        callOk, ok, statusText = pcall(serializeBinary,root,filename,saveSettings)
                                                                                                                        else
                                                                                                                            callOk, ok, statusText = pcall(serializeXML,root,filename,saveSettings)
                                                                                                                            end

                                                                                                                            if not callOk then
                                                                                                                                local runtimeError = ok
                                                                                                                                warn("[DexSerializer] ERRO durante o save: "..tostring(runtimeError))
                                                                                                                                ok = false
                                                                                                                                statusText = runtimeError
                                                                                                                            elseif not ok then
                                                                                                                                warn("[DexSerializer] Save nao concluido: "..tostring(statusText or "motivo desconhecido"))
                                                                                                                            end

                                                                                                                            -- Cleanup
                                                                                                                            if antiIdleConn then pcall(function() antiIdleConn:Disconnect() end) end
                                                                                                                                -- Ensure status UI is removed if present
                                                                                                                                if statusText and type(statusText.Remove) == "function" then
                                                                                                                                    pcall(statusText.Remove)
                                                                                                                                    end

                                                                                                                                    return ok, statusText
                                                                                                                                    end

                                                                                                                                    Serializer.Init = function(oldInd)
                                                                                                                                    oldIndex = oldInd

                                                                                                                                    gethiddenprop = env.gethiddenprop or env.getnspval
                                                                                                                                    getnspval = gethiddenprop
                                                                                                                                    getbspval = env.getbspval
                                                                                                                                    getnilinstances = env.getnilinstances
                                                                                                                                    getpcd = env.getpcd
                                                                                                                                    encodeBase64 = env.encodeBase64
                                                                                                                                    lz4compress = env.lz4compress
                                                                                                                                    classes = API.Classes
                                                                                                                                    hashmd5 = env.hashmd5

                                                                                                                                    if not getbspval and gethiddenprop and encodeBase64 then
                                                                                                                                        getbspval = function(obj,prop,enc)
                                                                                                                                        local binary = gethiddenprop(obj,prop) or ""
                                                                                                                                        if #binary == 0 then return nil end
                                                                                                                                            return enc and encodeBase64(binary) or binary
                                                                                                                                            end
                                                                                                                                            end
                                                                                                                                            end

                                                                                                                                            return Serializer
                                                                                                                                            end)()

                                                                                                                                            Main = (function()
                                                                                                                                            local Main = {}

                                                                                                                                            Main.FetchAPI = function()
                                                                                                                                            -- You should see if you can use ReflectionService here

                                                                                                                                            --local robloxVer = game:HttpGet("http://setup.roblox.com/versionQTStudio")
                                                                                                                                            local rawAPI

                                                                                                                                            if game:GetService("RunService"):IsStudio() then
                                                                                                                                                rawAPI = require(game.ReplicatedStorage.FullAPI)
                                                                                                                                                else
                                                                                                                                                    rawAPI = game:HttpGet("https://raw.githubusercontent.com/setup-rbxcdn/build-archive/master/data/production/builds/version-46693bc0bc244907/Full-API-Dump.json")
                                                                                                                                                    end

                                                                                                                                                    local api = type(rawAPI) == "string" and service.HttpService:JSONDecode(rawAPI) or rawAPI
                                                                                                                                                    local classes,enums = {},{}
                                                                                                                                                    local valueTypeRenames = {
                                                                                                                                                        Region3Int16 = "Region3int16",
                                                                                                                                                    }

                                                                                                                                                    -- Create every class first so superclass resolution does not depend on dump order.
                                                                                                                                                    for _,class in pairs(api.Classes) do
                                                                                                                                                        classes[class.Name] = {
                                                                                                                                                            Name = class.Name,
                                                                                                                                                            Properties = {},
                                                                                                                                                            Functions = {},
                                                                                                                                                            Events = {},
                                                                                                                                                            Callbacks = {},
                                                                                                                                                            Tags = {},
                                                                                                                                                        }
                                                                                                                                                    end

                                                                                                                                                    for _,class in pairs(api.Classes) do
                                                                                                                                                        local newClass = classes[class.Name]
                                                                                                                                                        newClass.Superclass = classes[class.Superclass]

                                                                                                                                                        if class.Tags then for c,tag in pairs(class.Tags) do newClass.Tags[tag] = true end end

                                                                                                                                                            for __,member in pairs(class.Members) do
                                                                                                                                                                local newMember = {}
                                                                                                                                                                newMember.Name = member.Name
                                                                                                                                                                newMember.Class = class.Name
                                                                                                                                                                newMember.Tags = {}
                                                                                                                                                                if member.Tags then for c,tag in pairs(member.Tags) do newMember.Tags[tag] = true end end

                                                                                                                                                                    local mType = member.MemberType
                                                                                                                                                                    if mType == "Property" then
                                                                                                                                                                        -- Normalize ValueType to a table with a Name field for consistency
                                                                                                                                                                        local vt = member.ValueType
                                                                                                                                                                        if type(vt) == "string" then
                                                                                                                                                                            vt = { Name = vt }
                                                                                                                                                                            elseif type(vt) == "table" and vt.Name == nil then
                                                                                                                                                                                -- Attempt to extract a name-like field if present
                                                                                                                                                                                for k,v in pairs(vt) do
                                                                                                                                                                                    if type(v) == "string" then vt.Name = v; break end
                                                                                                                                                                                        end
                                                                                                                                                                                        end
                                                                                                                                                                                        if vt and vt.Name then
                                                                                                                                                                                            vt.Name = valueTypeRenames[vt.Name] or vt.Name
                                                                                                                                                                                        end
                                                                                                                                                                                        newMember.ValueType = vt
                                                                                                                                                                                        newMember.Category = member.Category
                                                                                                                                                                                        newMember.Serialization = member.Serialization
                                                                                                                                                                                        -- AssetContentMap currently has no supported XML/binary descriptor.
                                                                                                                                                                                        if not vt or vt.Name ~= "AssetContentMap" then
                                                                                                                                                                                            table.insert(newClass.Properties,newMember)
                                                                                                                                                                                        end
                                                                                                                                                                                        elseif mType == "Function" then
                                                                                                                                                                                            newMember.Parameters = {}
                                                                                                                                                                                            newMember.ReturnType = member.ReturnType.Name
                                                                                                                                                                                            for c,param in pairs(member.Parameters) do
                                                                                                                                                                                                table.insert(newMember.Parameters,{Name = param.Name, Type = param.Type.Name})
                                                                                                                                                                                                end
                                                                                                                                                                                                table.insert(newClass.Functions,newMember)
                                                                                                                                                                                                elseif mType == "Event" then
                                                                                                                                                                                                    newMember.Parameters = {}
                                                                                                                                                                                                    for c,param in pairs(member.Parameters) do
                                                                                                                                                                                                        table.insert(newMember.Parameters,{Name = param.Name, Type = param.Type.Name})
                                                                                                                                                                                                        end
                                                                                                                                                                                                        table.insert(newClass.Events,newMember)
                                                                                                                                                                                                        end
                                                                                                                                                                                                        end

                                                                                                                                                                                                        classes[class.Name] = newClass
                                                                                                                                                                                                        end

                                                                                                                                                                                                        for _,enum in pairs(api.Enums) do
                                                                                                                                                                                                            local newEnum = {}
                                                                                                                                                                                                            newEnum.Name = enum.Name
                                                                                                                                                                                                            newEnum.Items = {}
                                                                                                                                                                                                            newEnum.Tags = {}

                                                                                                                                                                                                            if enum.Tags then for c,tag in pairs(enum.Tags) do newEnum.Tags[tag] = true end end
                                                                                                                                                                                                                for __,item in pairs(enum.Items) do
                                                                                                                                                                                                                    local newItem = {}
                                                                                                                                                                                                                    newItem.Name = item.Name
                                                                                                                                                                                                                    newItem.Value = item.Value
                                                                                                                                                                                                                    table.insert(newEnum.Items,newItem)
                                                                                                                                                                                                                    end

                                                                                                                                                                                                                    enums[enum.Name] = newEnum
                                                                                                                                                                                                                    end

                                                                                                                                                                                                                    local function getMember(class,member)
                                                                                                                                                                                                                    if not classes[class] or not classes[class][member] then return end
                                                                                                                                                                                                                        local result = {}

                                                                                                                                                                                                                        local currentClass = classes[class]
                                                                                                                                                                                                                        while currentClass do
                                                                                                                                                                                                                            for _,entry in pairs(currentClass[member]) do
                                                                                                                                                                                                                                result[#result+1] = entry
                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                currentClass = currentClass.Superclass
                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                table.sort(result,function(a,b) return a.Name < b.Name end)
                                                                                                                                                                                                                                return result
                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                return {
                                                                                                                                                                                                                                    Classes = classes,
                                                                                                                                                                                                                                    Enums = enums,
                                                                                                                                                                                                                                    GetMember = getMember
                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                Main.ResetSettings = function()
                                                                                                                                                                                                                                local function recur(t)
                                                                                                                                                                                                                                local res = {}
                                                                                                                                                                                                                                for set,val in pairs(t) do
                                                                                                                                                                                                                                    if type(val) == "table" and val._Recurse then
                                                                                                                                                                                                                                        res[set] = recur(val)
                                                                                                                                                                                                                                        else
                                                                                                                                                                                                                                            res[set] = val
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            return res
                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                            Settings = recur(DefaultSettings)
                                                                                                                                                                                                                                            end

                                                                                                                                                                                                                                            return Main
                                                                                                                                                                                                                                            end)()

                                                                                                                                                                                                                                            return {
                                                                                                                                                                                                                                                Init = function(oldindex)
                                                                                                                                                                                                                                                local api, e = Main.FetchAPI() -- TODO: only request new api on roblox updates?
                                                                                                                                                                                                                                                if not api then
                                                                                                                                                                                                                                                    return nil, "FetchAPI failed (" .. tostring(e) .. ")"
                                                                                                                                                                                                                                                    end
                                                                                                                                                                                                                                                    API = api

                                                                                                                                                                                                                                                    env = {}
                                                                                                                                                                                                                                                    env.writefile = writefile
                                                                                                                                                                                                                                                    env.appendfile = appendfile
                                                                                                                                                                                                                                                    env.getnilinstances = getnilinstances or get_nil_instances
                                                                                                                                                                                                                                                    env.gethiddenprop = gethiddenprop or gethiddenproperty
                                                                                                                                                                                                                                                    env.getnspval = getnspval
                                                                                                                                                                                                                                                    env.getbspval = getbspval
                                                                                                                                                                                                                                                    env.getpcd = getpcd or getpcdprop
                                                                                                                                                                                                                                                    env.encodeBase64 = (syn and syn.crypt.base64.encode) or base64encode or (crypt and crypt.base64encode)
                                                                                                                                                                                                                                                    env.lz4compress = lz4compress or (syn and syn.crypt.lz4.compress)
                                                                                                                                                                                                                                                    env.hashmd5 = (syn and function(s) return syn.crypt.custom.hash("md5",s) end) or (crypt and function(s) return crypt.hash(s,"md5") end)

                                                                                                                                                                                                                                                    -- Validate required environment functions to fail fast with clear message
                                                                                                                                                                                                                                                    local missing = {}
                                                                                                                                                                                                                                                    if type(env.writefile) ~= "function" then table.insert(missing, "writefile") end
                                                                                                                                                                                                                                                        if type(env.appendfile) ~= "function" then table.insert(missing, "appendfile") end
                                                                                                                                                                                                                                                            if #missing > 0 then
                                                                                                                                                                                                                                                                return nil, "Missing environment functions: " .. table.concat(missing, ", ")
                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                Main.ResetSettings()
                                                                                                                                                                                                                                                                Serializer.Init(oldindex)

                                                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                                                                end,

                                                                                                                                                                                                                                                                Save = function(object, filename, options)
                                                                                                                                                                                                                                                                return Serializer.SaveInstance(object, filename, options)
                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                            }
