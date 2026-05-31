# Momentum SaveInstancer

Momentum SaveInstancer is a wrapper around UniversalSynSaveInstance that works like a background asset logger.

When you press **Start**, it begins watching client-visible instances. While it is running, new models, folders, parts, tools, meshes, unions, UI objects, effects, sounds, and other replicated instances are snapshotted. When you press **Stop**, it writes a final lightweight `.rbxlx` and injects recovered snapshots into:

```text
ServerStorage
  MomentumRecoveredAssets
```

This is useful for games that temporarily replicate assets into `Workspace` and then move or destroy them later.

## Important limitations

- This cannot read true server-only `ServerStorage` contents from the client. Roblox FilteringEnabled prevents that.
- It only captures instances that become visible to the client under `Workspace` while Momentum is running.
- `ReplicatedStorage`, `Players`, `StarterGui`, and other non-Workspace services are ignored by default to avoid false captures.
- Server scripts and non-replicated server data still cannot be recovered by a client-side saveinstance.
- Snapshot mode uses memory because it clones assets as soon as they appear.
- Use this only in experiences you own, administer, or are authorized to inspect.

## Loadstring

```lua
local url = "https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/momentum_saveinstancer.luau"
local source = game:HttpGet(url, true)
local loader, err = loadstring(source, "Momentum SaveInstancer")
assert(loader, err)
local Momentum = loader()
```

The GUI opens automatically. Press **Start**, wait for assets to appear, then press **Stop** to write the final file. Keep **Light RBXLX** enabled for a smaller file that opens faster in Studio. Keep **Save Seen Live** enabled when assets are replicated from remotes and stay visible, like generated flower models.

## Manual API usage

```lua
local url = "https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/momentum_saveinstancer.luau"
local source = game:HttpGet(url, true)
local loader, err = loadstring(source, "Momentum SaveInstancer")
assert(loader, err)
local Momentum = loader()

Momentum.Start({
    InitialFilePath = "momentum_initial_" .. game.PlaceId,
    FinalFilePath = "momentum_final_" .. game.PlaceId,
    IgnorePlayerCharacters = true,
    IncludeLiveCaptured = true,
    GroupRecoveredByParent = true,
    OutputMode = "minimal",
    CompactFinalSave = true,
    RunInitialSave = false,
    FastCaptureDelay = 0,
    CaptureDelay = 0.75,
    CaptureServices = { "Workspace" },
    CapturePathPrefixes = { "Workspace" },
    IgnoreServices = {
        "ReplicatedStorage",
        "ReplicatedFirst",
        "StarterGui",
        "StarterPack",
        "StarterPlayer",
        "Players",
        "Lighting",
        "SoundService",
        "CoreGui",
    },
    MaxCapturedRoots = false,
    MaxSnapshotDescendants = 4000,
    SaveOptions = {
        ReadMe = true,
        ShowStatus = true,
        TreatUnionsAsParts = false,
        TreatUnreadableUnionsAsParts = false,
        IgnoreSpecialProperties = false,
        IgnoreSharedStrings = false,
        ScriptSourceHeader = false,
        LinkedSourceComment = false,
    },
})

-- Later:
Momentum.Stop()
```

## Advanced usage with a custom saveinstance loader

```lua
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/saveinstance.luau", true), "saveinstance")()
local Momentum = loadstring(game:HttpGet("https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/momentum_saveinstancer.luau", true), "Momentum SaveInstancer")()

Momentum.Start({
    SaveInstance = synsaveinstance,
    FinalFilePath = "my_recovered_map",
})
```

## Normal saveinstance usage

The original saveinstance entry point still works:

```lua
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/twepro823-beep/saveinstance/main/saveinstance.luau", true), "saveinstance")()

synsaveinstance({
    TreatUnionsAsParts = false,
    TreatUnreadableUnionsAsParts = false,
    IgnoreSpecialProperties = false,
    IgnoreSharedStrings = false,
    ReadMe = true,
    ScriptSourceHeader = false,
    LinkedSourceComment = false,
})
```

## New saveinstance extension

`saveinstance.luau` now accepts:

```lua
VirtualChildren = {
    [someParentInstance] = { childInstance1, childInstance2 },
}
```

These children are serialized under `someParentInstance` without changing the live game tree. Momentum uses this to place recovered snapshots under `ServerStorage/MomentumRecoveredAssets` in the final `.rbxlx`.

## Output modes

- `minimal` (default): saves a small `.rbxlx` containing only `ServerStorage/MomentumRecoveredAssets`. This opens much faster in Studio.
- `full`: saves the normal game plus recovered assets. Use only when you really need the whole map in the same file.
- `model`: saves only the recovered folder as `.rbxmx`.

## Remote-replicated asset support

- `FastCaptureDelay = 0` snapshots immediately so short-lived RemoteEvent assets are not missed.
- `CaptureDelay = 0.75` refreshes the snapshot after the model settles, catching children that arrive a moment later.
- `IncludeLiveCaptured = true` saves assets that were seen even if they are still in Workspace at Stop.
- `MaxCapturedRoots = false` removes the old hard root cap. Set a number if you want a safety cap.
- `CaptureServices = { "Workspace" }` makes the watcher listen to Workspace only by default.
- `CapturePathPrefixes = { "Workspace" }` can be narrowed, for example `{ "Workspace.ScenesServer" }`, when you only want one replicated asset tree.
- `IgnoreServices` ignores `ReplicatedStorage` and other services by default, so cached/shared assets are not captured as recovered server-spawned assets.
- `GroupRecoveredByParent = true` groups large bursts, such as many `Flower...` models under one parent folder, so Studio's Explorer is easier to open and inspect.
- Capture eligibility is no longer limited to a small class list. Momentum tries to clone any non-ignored Roblox `Instance`, then uses class checks only for final-file compaction.

## Credits and license

This project is based on UniversalSynSaveInstance:

https://github.com/luau/UniversalSynSaveInstance

Original credits belong to USSI and its contributors. This repository keeps the AGPL-3.0 license included in `LICENSE`.
