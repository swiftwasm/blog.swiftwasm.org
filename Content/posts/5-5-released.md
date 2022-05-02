---
date: 2021-11-29 10:10
description: SwiftWasm 5.5.0 with support for async/await and Apple Silicon has been released.
---

# SwiftWasm 5.5.0 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.5! Notably, in
this release we've added support for `async`/`await`. This new feature of Swift can be integrated
with JavaScript promises when you're using a new version of
[JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) that was recently tagged. See the corresponding
section below for more details.

Since multi-threading in WebAssembly is still not supported across all browsers
([Safari is the only one lagging behind](https://webassembly.org/roadmap/)), this release of
SwiftWasm doesn't include the Dispatch library and ships with a single-threaded cooperative executor. This means
that `actor` declarations in your code will behave as plain reference types and will all be scheduled
on the main thread. If you need true parallel computation, you’ll have to write
custom code against the
[Web Workers API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)
(either via JavaScriptKit or delegating to raw JavaScript) to synchronize
multiple SwiftWasm runtimes.

Additionally, 5.5.0 is the first release of SwiftWasm that supports Apple Silicon natively.
The latest version of [`carton`](https://github.com/swiftwasm/carton) (0.12.0)
will download the `arm64` distribution on Apple Silicon devices.

## New JavaScriptKit runtime

The 0.11 release of [JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) adds
support for `async`/`await` and `JSPromise` integration. Now instances of this
class have an effectful `async` property `value`. Here's example code that shows you how
can `fetch` browser API be used without callbacks:

```swift
import JavaScriptKit
import JavaScriptEventLoop

// This line is required for `JSPromise.value` to work.
JavaScriptEventLoop.installGlobalExecutor()

private let jsFetch = JSObject.global.fetch.function!
func fetch(_ url: String) -> JSPromise {
    JSPromise(jsFetch(url).object!)!
}

struct Response: Decodable {
    let uuid: String
}

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

var asyncButtonElement = document.createElement("button")
asyncButtonElement.innerText = "Fetch UUID demo"
asyncButtonElement.onclick = .object(JSClosure { _ in
    Task {
        do {
            let response = try await fetch("https://httpbin.org/uuid").value
            let json = try await JSPromise(response.json().object!)!.value
            let parsedResponse = try JSValueDecoder().decode(Response.self, from: json)
            alert(parsedResponse.uuid)
        } catch {
            print(error)
        }
    }

    return .undefined
})

_ = document.body.appendChild(asyncButtonElement)
```

Also, in this version of JavaScriptKit we're simplifying the `JSClosure` API. You no longer need to
release instances of this class manually, as they will be automatically garbage-collected by the browser
after neither your Swift code nor the JavaScript runtime hold any references to them. This is achieved with the new
`FinalizationRegistry` Web API, for which we had to significantly increase minimum browser versions
required for JavaScriptKit to work. See [`README.md`](https://github.com/swiftwasm/JavaScriptKit#readme)
in the project repository for more details.

We have to mention that there's still a possibility of reference cycles with this new API. `FinalizationRegistry`
doesn't implement full GC for JS closures, but it only solves dangling closure issue. For example,
in this code

```
var button = document.createElement("button")
button.onclick = .object(JSClosure { [button] in
  // this capture makes a reference cycle
  print(button)
})
```

a reference cycle is created

```
┌─> JSObject (button in Swift) -> HTMLElement (button in JS) ────┐
└── JSClosure (onclick in Swift) <─> Closure (onclick in JS) <───┘
```

In this case, when `button` element is removed from the main DOM tree, it cannot be deallocated.
The `onclick` closure is still referenced by the button itself. These reference cycles can be resolved
with the usual `weak` captures you're probably used to writing in your AppKit and UIKit code.

## Tokamak

Based on the improvements to JavaScriptKit and major work by our contributors, we're also tagging
a new 0.9.0 release of [Tokamak](https://github.com/TokamakUI/Tokamak), a SwiftUI-compatible
framework for building browser apps with WebAssembly. We've added:

- `Canvas` and `TimelineView` types;
- `onHover` modifier;
- `task` modifier for running `async` functions;
- Sanitizers for the `Text` view.

Tokamak v0.9.0 now requires Swift 5.4 or newer. Swift 5.5 (with SwiftWasm
5.5 when targeting the browser environment) is recommended.

## Acknowledgements

We'd like to thank [our sponsors](https://github.com/sponsors/swiftwasm) for their support, which
allowed us to continue working on the SwiftWasm toolchain and related projects.

Many thanks to [MacStadium](https://www.macstadium.com) for giving us access to Apple Silicon hardware.
Without their help it would be close to impossible to set up CI for enabling full M1 support in our toolchain.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of (in alphabetical order):

- [@agg23](https://github.com/agg23)
- [@carson-katri](https://github.com/carson-katri)
- [@ezraberch](https://github.com/ezraberch)
- [@Feuermurmel](https://github.com/Feuermurmel)
- [@kateinoigakukun](https://github.com/kateinoigakukun)
- [@MaxDesiatov](https://github.com/MaxDesiatov)
- [@mbrandonw](https://github.com/mbrandonw)
- [@PatrickPijnappel](https://github.com/PatrickPijnappel)
- [@yonihemi](https://github.com/yonihemi/)
- all of our users, and everyone working on the Swift project and libraries we depend on!
