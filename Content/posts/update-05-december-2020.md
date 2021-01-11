---
date: 2021-01-11 14:34
description: An update on what happened in the SwiftWasm ecosystem during December 2020.
---
# What's new in SwiftWasm #5

Happy New Year everyone! Here's a digest of what happened with [SwiftWasm](https://swiftwasm.org) in
December of 2020, published with a slight delay (it's 2021 already after all 😅).

## SwiftWasm community

One thing we forgot to mention in our November update is that the SwiftWasm community now has
[its own Discord server](https://discord.gg/ashJW8T8yp). In case you prefer Slack to Discord, we
recommend you to join the `#webassembly` channel in [the SwiftPM Slack
workspace](https://swift-package-manager.herokuapp.com/).

In December we saw a lot of projects built with SwiftWasm shared by the community. Here a few most
noteworthy:

* [An online Multi-Player Meme Party Game written in Swift](https://github.com/nerdsupremacist/memes),
using [Vapor](https://vapor.codes/) for backend and SwiftWasm with
[Tokamak](https://tokamak.dev) for frontend, built by [Mathias Quintero](https://github.com/nerdsupremacist).
* [Tic-tac-toe game](https://garrepi.dev/tic-tac-toe/) [built with SwiftWasm](https://github.com/johngarrett/tic-tac-toe) by [John Garrett](https://github.com/johngarrett).
* [WebAssembly example with React and SwiftWasm](https://expressflow.com/blog/posts/webassembly-example-with-react-and-swiftwasm) by
[Martin Vasko](https://github.com/martinvasko).

## Good first issues

Ever wanted to contribute to SwiftWasm projects, but unsure where to start? Here's a list of
issues that could be suitable for beginners:

* [swiftwasm/swift$29](https://github.com/swiftwasm/swift/issues/29): Fix compile error on test cases depending on platform
* [swiftwasm/carton#203](https://github.com/swiftwasm/carton/issues/203): Allow launching a specific browser with `carton test`
* [swiftwasm/carton#201](https://github.com/swiftwasm/carton/issues/201): Correctly handle failure to launch browser process while testing
* [swiftwasm/carton#199](https://github.com/swiftwasm/carton/issues/199): `--enable-test-discovery` is now deprecated
* [swiftwasm/carton#193](https://github.com/swiftwasm/carton/issues/193): Add `--host` option to `carton dev` and `carton test`
* [TokamakUI/Tokamak](https://github.com/TokamakUI/Tokamak/issues/350): Set up code coverage reports on GitHub Actions

## Documentation

### SwiftWasm book

We're working on tracking down all the possible edge cases when porting code from other
platforms in [the SwiftWasm book](https://book.swiftwasm.org/). Previously we were asked how to port
code that depends on the `Darwin` module on Apple platforms or `Glibc` on Linux. We recommend
using the `WASILibc` module, which obviously somewhat differs from libc on other platforms. We've
added [a corresponding note clarifying this](https://book.swiftwasm.org/getting-started/libc.html)
to the book.

## Toolchain

As the Swift team already announced [the release process for the 5.4
version](https://forums.swift.org/t/swift-5-4-release-process/41936), we started preparing our
corresponding SwiftWasm 5.4 release. The [`swiftwasm-release/5.4`](https://github.com/swiftwasm/swift/tree/swiftwasm-release/5.4)
branch in our fork now [tracks the upstream `release/5.4`
branch](https://github.com/swiftwasm/swift/pull/2380), as we plan to tag our own 5.4.0 later
this year.

Additionally, we made sure that the fork of our toolchain
[can be compiled on Apple Silicon Macs](https://github.com/swiftwasm/swift/pull/2405). While GitHub
Actions doesn't provide CI agents for the M1 architecture, the SwiftWasm toolchain can be built
locally for Apple Silicon, and we hope to provide a prebuilt distribution archive for it in some
future release.

### Experimental async/await support

[@kateinoigakukun](https://github.com/kateinoigakukun) enabled [experimental concurrency support
in SwiftWasm](https://github.com/swiftwasm/swift/pull/2408) and fixed several issues that
previously prevented us from enabling `async`/`await` in development snapshots. Currently, starting with
[swift-wasm-DEVELOPMENT-SNAPSHOT-2021-01-02-a](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-DEVELOPMENT-SNAPSHOT-2021-01-02-a),
the toolchain only supports a single-threaded task executor. This executor is suitable for usage in
standalone WASI hosts such as Wasmer or Wasmtime. Unfortunately, it blocks the JavaScript event loop
until all jobs are completed, and is unable to run any jobs created after the first event loop
cycle. While this makes it unsuitable for JavaScript environments, we were able to work around that
in JavaScriptKit as discussed in the next section.

## Libraries

### JavaScriptKit

[@kateinoigakukun](https://github.com/kateinoigakukun) started implementing [a Swift concurrency
task executor](https://github.com/swiftwasm/JavaScriptKit/pull/112) integrated with the JavaScript
event loop. There are still several issues, but it's working well as a proof of concept. This
experimental API allows us to utilize `async`/`await` in SwiftWasm apps for browsers and Node.js
like this:

```swift
import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.install()
let fetch = JSObject.global.fetch.function!.async

func printZen() async {
  let result = try! await fetch("https://api.github.com/zen").object!
  let text = try! await result.asyncing.text!()
  print(text)
}

JavaScriptEventLoop.runAsync {
  await printZen()
}
```

### WebAssembly Micro Runtime

[@kateinoigakukun](https://github.com/kateinoigakukun) published [a Swift WebAssembly runtime
package](https://github.com/swiftwasm/wamr-swift) powered by [the WebAssembly Micro Runtime
project](https://github.com/bytecodealliance/wasm-micro-runtime) (WAMR). This allows us to remove Wasmer
dependency from `carton` and embed the WebAssembly runtime in the `carton` binary for use in
commands such as `carton test`.

We were also able to test this package on Apple Silicon and submit [a PR
upstream](https://github.com/bytecodealliance/wasm-micro-runtime/pull/480) to make it work.

### DOMKit

Our long-term goal is to make [DOMKit](https://github.com/swiftwasm/DOMKit) the recommended library
for type-safe interactions with Web APIs in SwiftWasm. While it's still at an early stage, we've
updated it to [JavaScriptKit 0.9 and added support for `globalThis`](https://github.com/swiftwasm/DOMKit/pull/3).
[In a separate PR](https://github.com/swiftwasm/DOMKit/pull/4) we've cleaned up unused code and
fixed an event handlers crash.

### Tokamak

With enough changes to warrant a new release, we've published [Tokamak
0.6.0](https://github.com/TokamakUI/Tokamak/releases/tag/0.6.0), which introduced support for
the `Image` view loading images bundled as SwiftPM resources, implemented by
[@j-f1](https://github.com/j-f1). It also adds the `PreferenceKey` protocol and related modifiers.
developed by [@carson-katri](https://github.com/carson-katri).

Since then we've also added [the `PreviewProvider` protocol](https://github.com/TokamakUI/Tokamak/pull/328),
[an implementation of `TextEditor`](https://github.com/TokamakUI/Tokamak/pull/329), and updated
our [example code in `README.md` for script injection](https://github.com/TokamakUI/Tokamak/pull/332).
Additionally, a contribution from [David Hunt](https://github.com/foscomputerservices) [added
missing typealiases to TokamakDOM](https://github.com/TokamakUI/Tokamak/pull/331) that should improve
compatibility with SwiftUI, while [Jed Fox](https://github.com/j-f1) removed [redundant `path` element
from SVG output](https://github.com/TokamakUI/Tokamak/pull/341).

## Developer tools

### `carton`

We'd like to welcome [@thecb4](https://github.com/thecb4), who is the latest addition to the `carton`
maintainers team! Thanks to his work, [project targets were restructured for better
testability](https://github.com/swiftwasm/carton/pull/191), and
now [`test`](https://github.com/swiftwasm/carton/pull/198), [`dev`, and `bundle`](https://github.com/swiftwasm/carton/pull/196)
commands are covered with end-to-end tests.

There's [ongoing work](https://github.com/swiftwasm/carton/pull/195) to integrate [the WAMR
package](https://github.com/swiftwasm/wamr-swift) mentioned above with the `carton test` command.
Also, `carton` now [correctly handles system target dependencies
in `Package.swift`](https://github.com/swiftwasm/carton/pull/189).

On top of that, stack traces from
Chrome and Safari are [now supported in `carton dev` with proper symbol
demangling](https://github.com/swiftwasm/carton/pull/186), thanks to the work by [@j-f1](https://github.com/j-f1).
Additionally, [@yonihemi](https://github.com/yonihemi) submitted [a PR which integrates `carton`
with libSwiftPM](https://github.com/swiftwasm/carton/pull/194) allowing us to reuse its model types.

Most of these changes were included in [0.9.0](https://github.com/swiftwasm/carton/releases/tag/0.9.0)
and [0.9.1](https://github.com/swiftwasm/carton/releases/tag/0.9.1) releases published in December.

### `webidl2swift`

[`webidl2swift`](https://github.com/Apodini/webidl2swift) is the foundation on which
our [DOMKit](https://github.com/swiftwasm/DOMKit/) framework is built. Web API across all browsers is specified in
[the Web IDL format](https://en.wikipedia.org/wiki/Web_IDL), which can then be parsed to generate
type-safe bindings in Swift. The parser doesn't support all IDL files out there yet, but we've
[updated dependencies and updated the code
generator](https://github.com/Apodini/webidl2swift/pull/10) to certain JavaScriptKit types that
previously were deprecated.

### WasmTransformer

There were a few changes to [the WasmTransformer package](https://github.com/swiftwasm/WasmTransformer),
which we use in `carton` and intend to use in a few other dev tools. Specifically, we've [generalized
section info parsing](https://github.com/swiftwasm/WasmTransformer/pull/12) across different transformers,
[implemented a basic section size profiler](https://github.com/swiftwasm/WasmTransformer/pull/14),
and [made the `TypeSection` type public](https://github.com/swiftwasm/WasmTransformer/pull/15) to
make it easier to analyze sections of WebAssembly binaries.

### Gravity

We're excited to announce our new developer tool enabled by WasmTransformer.
[Gravity](https://github.com/swiftwasm/gravity) is a binary code size profiler for WebAssembly built
with WasmTransformer, [SwiftUI](https://developer.apple.com/xcode/swiftui/), and
[TCA](https://github.com/pointfreeco/swift-composable-architecture/). It's an application for macOS
that allows you to open a WebAssembly binary and view the size of different sections. Contents of
some of the sections is also parsed for further analysis.

## Contributions

A lot of our progress with SwiftWasm wouldn't be possible without payments from our GitHub Sponsors.
Their contribution is deeply appreciated and allows us to spend more time on SwiftWasm projects. You can
see the list of sponsors and make your contribution on [our SwiftWasm organization sponsorship
page](https://github.com/sponsors/swiftwasm), or personal sponsorship pages of [Carson
Katri](https://github.com/sponsors/carson-katri), [Yuta
Saito](https://github.com/sponsors/kateinoigakukun) and [Max
Desiatov](https://github.com/sponsors/MaxDesiatov).

Thanks for reading! 👋
