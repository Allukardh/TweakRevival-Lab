# Device validation (pending)

Target: iPhone 15 Pro Max / iOS 17.3.1 / RootHide. Never use irreplaceable photos.

| Check | Expected | Status |
| --- | --- | --- |
| Load with defaults | Native Photos behaviors | Untested |
| Alert diagnostic | Log alert shape without media details | Untested |
| Single photo, dry run | Native confirmation stays | Untested |
| Single disposable photo, bypass | Goes to Recently Deleted | Untested |
| Video and multi-selection | Recoverable deletion semantics | Untested |
| Recently Deleted permanent delete | **Native warning remains** | Untested |
| Shared album removal | **Native warning remains** | Untested |
| iCloud sync | Native recovery semantics | Untested |
| Zoom diagnostic | Finds exact viewer class | Untested |
| Zoom modification allowlisted | Only photo viewer changes | Untested |
| Existing Snail tweak coexists | No crashes | Untested |
| Rootless device | Installs and injects | Untested |
| RootHide device | Installs and injects | Untested |
| Uninstall | Native behavior restored | Untested |

**STOP on crashes, lost files, unexpected permanent deletion or sync problems.**
