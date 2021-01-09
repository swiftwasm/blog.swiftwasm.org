---
date: 2021-12-11 14:34
description: An update on what happened in the SwiftWasm ecosystem during December 2020.
---
# What's new in SwiftWasm #5

Happy New Year everyone! Published with a slight delay (it's 2021 already after all), here's a
digest of what happened with [SwiftWasm](https://swiftwasm.org) in December of 2020.

## SwiftWasm community

One thing we forgot to mention in our November update is that the SwiftWasm community now has
[its own Discord server](https://discord.gg/ashJW8T8yp). In case you prefer Slack to Discord, we
recommend you to join the `#webassembly` channel in [the SwiftPM Slack
workspace](https://swift-package-manager.herokuapp.com/).

In December we saw a lot of projects built with SwiftWasm shared by the community. Here a few most
noteworthy:

* [An online Multi-Player Meme Party Game written in Swift](https://github.com/nerdsupremacist/memes),
using [Vapor](https://vapor.codes/) for backend and SwiftWasm with
[Tokamak](https://tokamak.dev) for frontend built by [Mathias Quintero](https://github.com/nerdsupremacist).
* [Tic-tac-toe game](https://garrepi.dev/tic-tac-toe/) [built with SwiftWasm](https://github.com/johngarrett/tic-tac-toe) by [John Garrett](https://github.com/johngarrett).
* [Example of SwiftWasm and React integration](https://expressflow.com/blog/posts/webassembly-example-with-react-and-swiftwasm) by
[Martin Vasko](https://github.com/martinvasko).

## Documentation

### SwiftWasm book

We're working on tracking down all the possible edge cases when porting code from other
platforms in [the SwiftWasm book](https://book.swiftwasm.org/). Previously we were asked how to port
code that depends on the `Darwin` module on Apple platforms and/or `Glibc` on Linux. We recommend
using the `WASILibc` module, which obviously somewhat differs from libc on other platforms. We've
added [a corresponding chapter clarifying this](https://book.swiftwasm.org/getting-started/libc.html)
to the book.

## Toolchain

As the Swift team already announced [the release process for the 5.4
version](https://forums.swift.org/t/swift-5-4-release-process/41936), we started preparing for the
convergence of SwiftWasm 5.4. The [`swiftwasm-release/5.4`](https://github.com/swiftwasm/swift/tree/swiftwasm-release/5.4)
branch in our fork now [tracks the upstream `release/5.4`
branch](https://github.com/swiftwasm/swift/pull/2380), as we plan to tag our own 5.4.0 release later
this year.

Additionally, we've made sure that the fork of our toolchain
[can be compiled on Apple Silicon Macs](https://github.com/swiftwasm/swift/pull/2405). While GitHub
Actions doesn't provide CI agents built on M1 architecture, the SwiftWasm toolchain can be built
locally for Apple Silicon, and we hope to provide a distribution archive for it in some future release.

### Experimental async/await support

[@kateinoigakukun](https://github.com/kateinoigakukun) enabled [experimental concurrency supported
in SwiftWasm](https://github.com/swiftwasm/swift/pull/2408) while fixing several issues that
previously prevented us from doing that in development snapshots. Currently, starting with
[swift-wasm-DEVELOPMENT-SNAPSHOT-2021-01-02-a](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-DEVELOPMENT-SNAPSHOT-2021-01-02-a)
the toolchain only supports a single-threaded task executor. This executor is suitable for usage in
standalone WASI hosts such as Wasmer or Wasmtime. Unfortunately, it blocks the JavaScript event loop
until all jobs are completed, and is unable to run any jobs created after the first event loop
cycle. While this makes it unsuitable for running in JavaScript environments, we were able to fix
this in JavaScriptKit as discussed in the next section.

## Libraries

### JavaScriptKit

[@kateinoigakukun](https://github.com/kateinoigakukun) started implementing [a Swift concurrency
task executor]((https://github.com/swiftwasm/JavaScriptKit/pull/112)) integrated with the JavaScript
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

### WebAssembly Micro Runtime (WAMR)

[@kateinoigakukun](https://github.com/kateinoigakukun) published [a Swift WebAssembly runtime
package](https://github.com/swiftwasm/wamr-swift) powered by [the WebAssembly Micro Runtime
project](https://github.com/bytecodealliance/wasm-micro-runtime). This allows us to remove Wasmer
dependency from `carton` and embed the WebAssembly runtime in the `carton` binary for use in
commands such as `carton test`.

We were also able to test this package on Apple Silicon and submitted [a PR upstream] to make it
work.

### DOMKit

Our long-term goal is to make [DOMKit](https://github.com/swiftwasm/DOMKit) the recommended library
for type-safe interactions with Web APIs in SwiftWasm. While it's still at an early stage, we've
updated it to [JavaScriptKit 0.9 and added support for
`globalThis`](https://github.com/swiftwasm/DOMKit/pull/3). [In a separate
PR](https://github.com/swiftwasm/DOMKit/pull/4) we've cleaned up unused code and fixed an event
handlers crash.

### Tokamak
This release introduces support for the `Image` view, which can load images bundled as SwiftPM resources,
implemented by [@j-f1](https://github.com/j-f1). It also adds the `PreferenceKey` protocol and related modifiers.
developed by [@carson-katri](https://github.com/carson-katri) https://github.com/TokamakUI/Tokamak/releases/tag/0.6.0

Add `PreviewProvider` protocol https://github.com/TokamakUI/Tokamak/pull/328
Add `TextEditor` implementation https://github.com/TokamakUI/Tokamak/pull/329
Update script injection code in `README.md` https://github.com/TokamakUI/Tokamak/pull/332
Added some missing TokamakDOM/Core type typealiases https://github.com/TokamakUI/Tokamak/pull/331 by [David Hunt](https://github.com/foscomputerservices)
Remove extra `path` element https://github.com/TokamakUI/Tokamak/pull/341 by [@j-f1](https://github.com/j-f1)

## Developer tools

### `carton`

We'd like to welcome [@thecb4](https://github.com/thecb4), who is the latest addition to the
`carton` maintainers team.

Use WAMR for `carton test` https://github.com/swiftwasm/carton/pull/195

Add support for Chrome and Safari stack traces https://github.com/swiftwasm/carton/pull/186 by [@j-f1](https://github.com/j-f1)

Add `test` command test with no arguments https://github.com/swiftwasm/carton/pull/198
Add tests for `dev` and `bundle` commands https://github.com/swiftwasm/carton/pull/196
Add Dev tests and fix hard coded paths https://github.com/swiftwasm/carton/pull/192
Changes to project structure to allow for better testability https://github.com/swiftwasm/carton/pull/191
by [@thecb4](https://github.com/thecb4)

https://github.com/swiftwasm/carton/releases/tag/0.9.0
https://github.com/swiftwasm/carton/releases/tag/0.9.1

Mark all commands as implemented in `README.md` https://github.com/swiftwasm/carton/pull/180

Fix parsing system targets in `Package.swift` https://github.com/swiftwasm/carton/pull/189

Use libSwiftPM instead of custom model types https://github.com/swiftwasm/carton/pull/194 by [@yonihemi](https://github.com/yonihemi)


### `webidl2swift`

Update arg parser, fix deprecated JSKit types https://github.com/Apodini/webidl2swift/pull/10

Update to latest JavaScriptKit https://github.com/Apodini/webidl2swift/pull/8

### WasmTransformer

Generalize section info parsing in transformers https://github.com/swiftwasm/WasmTransformer/pull/12
Implement a basic section size profiler https://github.com/swiftwasm/WasmTransformer/pull/14
Make `TypeSection` public, rename `sizeProfiler` https://github.com/swiftwasm/WasmTransformer/pull/15

### Gravity

Binary code size profiler for WebAssembly built with [WasmTransformer](https://github.com/swiftwasm/WasmTransformer), [SwiftUI](https://developer.apple.com/xcode/swiftui/), and [TCA](https://github.com/pointfreeco/swift-composable-architecture/). https://github.com/swiftwasm/gravity

## Contributions

A lot of our progress with SwiftWasm wouldn't be possible without payments from our GitHub Sponsors.
Their contribution is deeply appreciated and allows us to spend more time on SwiftWasm projects. You can
see the list of sponsors and make your contribution on [our SwiftWasm organization sponsorship
page](https://github.com/sponsors/swiftwasm), or personal sponsorship pages of [Carson
Katri](https://github.com/sponsors/carson-katri), [Yuta
Saito](https://github.com/sponsors/kateinoigakukun) and [Max
Desiatov](https://github.com/sponsors/MaxDesiatov).

Thanks for reading! 👋
