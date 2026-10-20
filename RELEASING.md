# Publishing a SnapVela release

1. Update the package version in `tweaks/SnapVela/control`, CHANGELOG.md, and `RELEASE_NOTES.md`.
2. Commit changes, verify Actions rootless/roothide matrix is successful.
3. Push a `v*` tag pointing to the reviewed commit, for example:

```sh
git tag v0.1.0-alpha.2
git push origin v0.1.0-alpha.2
```

4. The tag triggers dual-scheme builds on macOS. Only after **both** succeed does GitHub Actions create a **prerelease** with `SnapVela-rootless.deb` and `SnapVela-roothide.deb`, and validate each architecture.
5. A successful release is still not a device test. Update `VALIDATION.md` from genuine testing before calling a version stable.

**First release exception:** a single bootstrap commit with the exact message `release: publish SnapVela alpha` triggers the same dual-build pipeline to create `v0.1.0-alpha.1` automatically. Subsequent releases should use tags. Keep both variants in every Release.
