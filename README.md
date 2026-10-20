# TweakRevival-Lab

Public clean-room lab for fixing and modernizing jailbreak tweaks.

## Projects

**[SnapVela](tweaks/SnapVela/)** - original experiment to simplify photo deletion confirmation and increase photo zoom in Apple's Photos app.

**Status: experimental.** The original Snail tweak's zoom worked in the user's iOS 17.3.1 test but skip-delete did not. SnapVela is an independent rewrite of the *behavior*, not a source-code fork.

## Build/release policy

- Every version tag triggers [GitHub Actions](.github/workflows/build.yml) builds of **both Rootless and RootHide .deb**.
- Release is blocked if either build fails. The pipeline publishes a **prerelease** only, not a verified stable release.
- Normal pushes and PRs run build checks but don't create releases.
- Source compilation does not prove that iOS 17.3.1 can safely skip a confirmation.
- The tweak operates only in Photos and ships with deletion and zoom interventions disabled.

## Development

[SnapVela documentation](tweaks/SnapVela/README.md) · [Test matrix](tweaks/SnapVela/VALIDATION.md)

Theos: https://theos.dev/docs/rootless · RootHide development: https://github.com/roothide/Developer

## Licensing

New source is licensed MIT. No third-party binaries or unlicensed original tweak code are included.
