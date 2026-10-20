# SnapVela — experimental alpha

**Experimental prototype. Not validated in Photos.app on iOS 17.3.1.**

This prerelease contains *two distinct builds* of the same original tweak:
- `SnapVela-rootless.deb` — **Rootless** package (`iphoneos-arm64`).
- `SnapVela-roothide.deb` — **RootHide** package (`iphoneos-arm64e`).

Both are compiled by the same public GitHub Actions run. A passed CI build verifies compilation and package structure only, **not** that deletion confirmations can safely be bypassed.

## Functionality

- Experimental, conservative attempt to avoid a redundant photo/video deletion confirmation, by calling Photos' original callback instead of deleting media directly.
- Optional extended zoom, restricted to exact allowlisted photo-viewer class names.
- Both features are **OFF by default**; diagnostic logs and dry-run are available.

## Safety

**Do not immediately enable skip delete on a valuable photo library.** First use disposable photos with diagnostics/dry-run and confirm that photos land in the Recently Deleted album. Normal permanent-delete confirmation must always remain; the actual iOS 17 behavior is not yet verified.

See [SnapVela README](https://github.com/Allukardh/TweakRevival-Lab/tree/main/tweaks/SnapVela) and [validation matrix](https://github.com/Allukardh/TweakRevival-Lab/blob/main/tweaks/SnapVela/VALIDATION.md).

Do not install both architecture variants; use the package matching your jailbreak environment.
