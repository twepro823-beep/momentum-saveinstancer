# Momentum SaveInstancer

Momentum SaveInstancer is a secondary project built on top of UniversalSynSaveInstance. It watches client-visible instances that appear under `Workspace`, snapshots new replicated assets quickly, and writes a final lightweight `.rbxlx` with recovered assets placed under `ServerStorage/MomentumRecoveredAssets`.

Main files live in [`saveinstance/`](saveinstance/):

- [`momentum_saveinstancer.luau`](saveinstance/momentum_saveinstancer.luau) - GUI, watcher, Start/Stop API, and recovered asset flow.
- [`saveinstance.luau`](saveinstance/saveinstance.luau) - UniversalSynSaveInstance-based serializer with `VirtualChildren` support.
- [`saveinstance/README.md`](saveinstance/README.md) - usage examples, limitations, and advanced options.

## Quick Start

```lua
local url = "https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/momentum_saveinstancer.luau"
local source = game:HttpGet(url, true)
local loader, err = loadstring(source, "Momentum SaveInstancer")
assert(loader, err)
local Momentum = loader()
```

The GUI opens automatically. Press **Start**, let the game reveal assets under `Workspace`, then press **Stop**. Keep **Light RBXLX** and **Save Seen Live** enabled for replicated assets that stay in Workspace, like remote-spawned flowers. The initial baseline save is optional and disabled by default.

By default Momentum ignores `ReplicatedStorage` and other non-Workspace services, has no hard captured-root cap, and groups recovered assets by their original parent path. You can narrow capture to a tree like `Workspace.ScenesServer` with:

```lua
Momentum.Start({
    CapturePathPrefixes = { "Workspace.ScenesServer" },
})
```

## Important

This tool cannot read true server-only `ServerStorage` from the client. It only captures instances that become visible to the client under `Workspace` while Momentum is running. Use it only in experiences you own, administer, or are authorized to inspect.

## Credits

Based on UniversalSynSaveInstance:

https://github.com/luau/UniversalSynSaveInstance

Original credits belong to USSI and its contributors.

## License

AGPL-3.0. See [`LICENSE`](LICENSE).
