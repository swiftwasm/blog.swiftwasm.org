---
date: 2021-12-04 14:34
description: An update on what happened in the SwiftWasm ecosystem during December 2020.
---
# What's new in SwiftWasm #5

Happy New Year everyone! Published with a slight delay (it's 2021 already after all), here's a
digest of what happened with SwiftWasm in December of 2020.

One more thing

Discord https://discord.gg/ashJW8T8yp Slack https://swift-package-manager.herokuapp.com/

## SwiftWasm community

[An online Multi-Player Meme Party Game written in Swift](https://github.com/nerdsupremacist/memes),
using [Vapor](https://vapor.codes/) for backend and SwiftWasm with
[Tokamak](https://tokamak.dev) for frontend built by [Mathias Quintero](https://github.com/nerdsupremacist).

https://garrepi.dev/tic-tac-toe/ https://github.com/johngarrett/tic-tac-toe built by [John Garrett](https://github.com/johngarrett).

WebAssembly example with React and SwiftWasm https://expressflow.com/blog/posts/webassembly-example-with-react-and-swiftwasm

## Documentation

### SwiftWasm book

`WASILibc` module https://book.swiftwasm.org/getting-started/libc.html

## Toolchain

Add `swiftwasm-release/5.4` to `pull.yml` https://github.com/swiftwasm/swift/pull/2380
https://github.com/swiftwasm/swift/pull/2405

### Experimental async/await support

[@kateinoigakukun](https://github.com/kateinoigakukun) activated [concurrency feature on wasm32 with several issue fixes](https://github.com/swiftwasm/swift/pull/2408). Currently the toolchain only supports standalone single thread task executor. 
The standalone executor is suitable for running in CLI Wasm runtimes like wasmer or wasmtime. But it blocks JavaScript event loop until all jobs are completed, and is unable to run any jobs created after the first event loop, so it's not suitable for running in JavaScript environments.

The concurrency support has been enabled since [swift-wasm-DEVELOPMENT-SNAPSHOT-2021-01-02-a](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-DEVELOPMENT-SNAPSHOT-2021-01-02-a).


## Libraries

### JavaScriptKit

[@kateinoigakukun](https://github.com/kateinoigakukun) started to implement [a Swift concurrency task executor cooperating with JavaScript's event loop](https://github.com/swiftwasm/JavaScriptKit/pull/112). There are still several issues, but it's well working as a PoC. Current experimental API allows us to write asynchronous programs in async/await style like this. 

```swift
import JavaScriptEventLoop
import JavaScriptKit

JavaScriptEventLoop.install()
let fetch = JSObject.global.fetch.function!.async

func printZen() async {
  let result = await try! fetch("https://api.github.com/zen").object!
  let text = await try! result.asyncing.text!()
  print(text)
}

JavaScriptEventLoop.runAsync {
  await printZen()
}
```

### WebAssembly Micro Runtime (WAMR)

Add support for Apple Silicon on macOS https://github.com/bytecodealliance/wasm-micro-runtime/pull/480

[@kateinoigakukun](https://github.com/kateinoigakukun) published [a Swift WebAssembly runtime package](https://github.com/swiftwasm/wamr-swift) powered by [WAMR](https://github.com/bytecodealliance/wasm-micro-runtime). This allows us to remove wasmer command dependency from carton and distribute carton as a single binary.



### DOMKit

Use MIT license https://github.com/swiftwasm/DOMKit/pull/2
Update to JavaScriptKit 0.9, add `Global` helpers https://github.com/swiftwasm/DOMKit/pull/3
Cleanup unused code, fix event handlers crash https://github.com/swiftwasm/DOMKit/pull/4

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
