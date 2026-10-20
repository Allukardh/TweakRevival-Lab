# SnapVela (experimental)

Clean-room Theos tweak that injects **only into Apple's Photos app**.

It explores two independent functions:
1. Suppress only recognized, ordinary deletion confirmation prompts while calling Photos' original action handler (not permanent-delete methods).
2. Extend zoom for explicitly allowlisted UIScrollView class names.

**Both interventions ship disabled. The iOS 17.3.1 behavior is not confirmed.**

## Configuration

Preference file: /var/mobile/Library/Preferences/com.allukardh.snapvela.plist

Copy settings.example.plist there. Supported keys:
- SkipConfirmation=false (default). Enables bypass attempt.
- DryRun=true (default). Keep dialog visible even when identified.
- DiagnosticAlerts=false. Log alert count and whether recognized.
- ExtendedZoom=false. Enable bounded zoom only in exact class allowlist.
- DiagnosticZoom=false. Log distinct zoom classes, not media contents.
- ZoomClassNames=[] (default). Populate from diagnostic on device.
- ZoomMaxScale=24. Bounded 2–40, not literally infinite.

## Build

Install Theos + SDK. RootHide builds require https://github.com/roothide/theos.

    make clean package THEOS_PACKAGE_SCHEME=rootless
    make clean package THEOS_PACKAGE_SCHEME=roothide

The GitHub Actions matrix builds both and creates an *experimental prerelease* from a v* tag only if both builds pass.

## Validation

Keep photos backed up. Start with default settings. Use disposable images only. Turn on DiagnosticAlerts, then enable SkipConfirmation with DryRun still true. If a normal deletion alert is identified, test one disposable image with DryRun=false and verify in Recently Deleted. Test permanent deletion from Recently Deleted and removal from shared albums: **neither may ever be auto-confirmed**. If there is any unexpected behavior, uninstall immediately. See [VALIDATION.md](VALIDATION.md).

For zoom, DiagnosticZoom can reveal full-screen photo scroll view class names; set ZoomClassNames explicitly to the tested class before ExtendedZoom=true. Current implementation might not match private Photos views and is not verified.

## Limitations and rollback

The underlying Photos alert may differ on iOS 17; UIKit handlers may expect a presented alert's lifecycle. No functionality is guaranteed. Disable SkipConfirmation and ExtendedZoom, restart Photos, or uninstall using your package manager. In RootHide you can additionally turn off tweak injection into Photos.

This does not include or redistribute Snail's original tweak binary or original source.
