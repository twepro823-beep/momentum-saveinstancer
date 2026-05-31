# Momentum SaveInstancer

Momentum SaveInstancer is a secondary project built on top of UniversalSynSaveInstance. It runs a normal baseline save, watches client-visible instances in the background, snapshots new assets, and writes a final `.rbxlx` with recovered missing assets placed under `ServerStorage/MomentumRecoveredAssets`.

Main files live in [`saveinstance/`](saveinstance/):

- [`momentum_saveinstancer_v2.luau`](saveinstance/momentum_saveinstancer_v2.luau) - GUI, watcher, Start/Stop API, and recovered asset flow.
- [`saveinstance.luau`](saveinstance/saveinstance.luau) - UniversalSynSaveInstance-based serializer with `VirtualChildren` support.
- [`saveinstance/README.md`](saveinstance/README.md) - usage examples, limitations, and advanced options.

## Quick Start

```lua
local url = "https://raw.githubusercontent.com/twepro823-beep/momentum-saveinstancer/main/saveinstance/momentum_saveinstancer_v2.luau"
local source = game:HttpGet(url, true)
local loader, err = loadstring(source, "Momentum SaveInstancer")
assert(loader, err)
local Momentum = loader()
```

The GUI opens automatically. Press **Start**, let the game reveal assets, then press **Stop** to write the final save.

## Important

This tool cannot read true server-only `ServerStorage` from the client. It only captures instances that become visible to the client while Momentum is running. Use it only in experiences you own, administer, or are authorized to inspect.

## Credits

Based on UniversalSynSaveInstance:

https://github.com/luau/UniversalSynSaveInstance

Original credits belong to USSI and its contributors.

## License

AGPL-3.0. See [`LICENSE`](LICENSE).
