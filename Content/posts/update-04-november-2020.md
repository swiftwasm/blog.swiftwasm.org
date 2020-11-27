---
date: 2020-11-30 14:34
description: An update on what happened in the SwiftWasm ecosystem during November 2020.
---
# What's new in SwiftWasm #4

## SwiftWasm 5.3.0 and 5.3.1 releases

As you may have seen in [our previous post](https://blog.swiftwasm.org/posts/5-3-released/), we've
published [our first stable
release](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-5.3.0-RELEASE) recently. Shortly
after that, [@flavio](https://github.com/flavio) reported [an issue
with `JSONDecoder`](https://github.com/swiftwasm/swift/issues/2223). Following [an
investigation](https://github.com/swiftwasm/swift/pull/2240) by
[@kateinoigakukun](https://github.com/kateinoigakukun) into the root cause of the issue, we've
published [SwiftWasm
5.3.1](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-5.3.1-RELEASE), which also
included updates from the upstream 5.3.1 patch release.

(If you're interested in technical details, the `JSONDecoder` issue was caused by a peculiar
assumption about memory layout in Swift runtime, which wasn't applicable to WebAssembly's linear
memory. [Check the PR diff](https://github.com/swiftwasm/swift/pull/2240/files) for
more details.)

## Libraries

### JavaScriptKit

A major update since the latest 0.8.0 release of JavaScriptKit is [newly added support
for throwing functions](https://github.com/swiftwasm/JavaScriptKit/pull/102) developed
by [@kateinoigakukun](https://github.com/kateinoigakukun). It required an update
to the JavaScript runtime part, but was an additive change to the Swift API. It's going to be
included in [the 0.9.0 release](https://github.com/swiftwasm/JavaScriptKit/pull/109) of JavaScriptKit.

[A PR with support for Asyncify transformation](https://github.com/swiftwasm/JavaScriptKit/pull/107)
was created by [@yonihemi](https://github.com/yonihemi). It allows calling asynchronous JavaScript
APIs with Swift code that looks as plain synchronous code, but through proper suspension that
doesn't block browser rendering. The PR has some implications on how we build things, especially as
it requires a specific optimizer transformation. It is still in the draft stage, and you're welcome
to contribute to the ongoing discussion.

### Tokamak

Following [the 0.5.0 release](https://github.com/TokamakUI/Tokamak/releases/tag/0.5.0), which added
support for the latest `carton`, we published [a small 0.5.1
patch](https://github.com/TokamakUI/Tokamak/releases/tag/0.5.1) with support for editing Tokamak
projects in Xcode with working autocomplete. Not long after that [an important
bugfix](https://github.com/TokamakUI/Tokamak/pull/301) landed in
[0.5.2](https://github.com/TokamakUI/Tokamak/releases/tag/0.5.2), which fixed an issue with display
order of updated views in the DOM renderer.

### OpenCombine

We still use [a fork of OpenCombine](https://github.com/TokamakUI/OpenCombine) in Tokamak due to
our custom implementation of the `ObservableObject` protocol. In addition to that, our fork
also contained some changes to the package manifest to make it build with SwiftWasm, but they
made it incompatible with non-Wasm platforms. This issue was [resolved in the upstream OpenCombine
repository](https://github.com/OpenCombine/OpenCombine/pull/191), which reduced the amount of
customizations we apply, and brings us closer to using the upstream repository as is.

## Developer tools

### WasmTransformer

[@kateinoigakukun](https://github.com/kateinoigakukun)
[implemented](https://github.com/swiftwasm/WasmTransformer/commit/d79d945731e03a10cb2806cbafc0be0113a2b9bf)
a `stripCustomSections` transformation in [the `WasmTransformer`
library](https://github.com/swiftwasm/WasmTransformer). [According to the
spec](https://webassembly.github.io/spec/core/appendix/custom.html), data in custom sections should
not contribute to observed behavior of a given binary. In the case of binaries produced by
SwiftWasm, custom sections contain debugging information that can now be stripped with
`WasmTransformer`.

### `carton`

Previously, custom sections were stripped to reduce final binary size as a build step in `carton
bundle` with the `wasm-strip` utility from [WABT](https://github.com/webassembly/wabt). Thanks to
the new transformation in `WasmTransformer`, WABT is no longer needed as a dependency of `carton`,
which makes installation for our end users simpler and faster.

Initial support for presenting crash stack traces directly in `carton` has been completed, starting with [Firefox support](https://github.com/swiftwasm/carton/pull/162). Support for more browsers will be added in separate PRs.

There was also work on [file downloader cleanup](https://github.com/swiftwasm/carton/pull/171), [support for browser testing](https://github.com/swiftwasm/carton/pull/173), and [simpler URLs for main bundle
resources](https://github.com/swiftwasm/carton/pull/176). As soon as these are merged, a new version
of `carton` will be tagged that will use the latest 5.3.1 release of SwiftWasm.

## Contributions

A lot of the progress wouldn't be possible without payments from our GitHub Sponsors. Their
contribution is deeply appreciated and allows us to spend more time on SwiftWasm projects. You can
see the list of sponsors and make your contribution on the sponsorship pages of [Carson
Katri](https://github.com/sponsors/carson-katri), [Yuta
Saito](https://github.com/sponsors/kateinoigakukun) and [Max
Desiatov](https://github.com/sponsors/MaxDesiatov).

Thanks for reading! 👋
