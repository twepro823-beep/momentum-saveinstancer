# Momentum SaveInstancer

Momentum SaveInstancer is a wrapper around UniversalSynSaveInstance that works like a background asset logger.

When you press **Start**, it begins watching client-visible instances and runs a normal baseline save. While it is running, every new model, folder, part, tool, mesh, union, or other replicated instance is snapshotted. When you press **Stop**, it writes a final `.rbxlx` and injects recovered missing snapshots into:

```text
ServerStorage
  MomentumRecoveredAssets
```

This is useful for games that temporarily replicate assets to the client and then move or destroy them later.

## Important limitations

- This cannot read true server-only `ServerStorage` contents from the client. Roblox FilteringEnabled prevents that.
- It only captures instances that become visible to the client while Momentum is running.
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

The GUI opens automatically. Press **Start**, wait for assets to appear, then press **Stop** to write the final file.

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

## Credits and license

This project is based on UniversalSynSaveInstance:

https://github.com/luau/UniversalSynSaveInstance

Original credits belong to USSI and its contributors. This repository keeps the AGPL-3.0 license included in `LICENSE`.
