---
date: 2021-11-29 10:10
description: SwiftWasm 5.5.0 with support for `async`/`await` and Apple Silicon has been released.
---

# SwiftWasm 5.5.0 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.5! Notably, in
this release we've added support for `async`/`await`. This new feature of Swift can be integrated
with JavaScript promises when you're using a new version of
[JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) that was recently tagged. See the corresponding
section below for more details.

Since multi-threading in WebAssembly is still not supported across all browsers
([Safari is the only one lagging behind](https://webassembly.org/roadmap/)), this release of
SwiftWasm doesn't include the Dispatch library and ships with single-threaded cooperative executor. This means
that `actor` declarations in your code will behave as plain reference type and will all be scheduled
on the main thread. You should rely on scheduling your CPU-bound work manually with the [Web Workers
API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers), using
JavaScriptKit or delegating to raw JavaScript if this is needed.

Additionally, 5.5.0 is the first release of SwiftWasm that supports Apple Silicon natively.
Use the latest version of [`carton`](https://github.com/swiftwasm/carton) (0.12.0), which will download the native distribution
automatically on supported hardware.

## New JavaScriptKit runtime

Accompanying 0.11 release of [JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) adds
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
release instances of this class manually, they're automatically garbage-collected by the browser
after your Swift code no longer has any references to them. This is achieved with the new
`FinalizationRegistry` Web API, for which we had to significantly increase minimum browser versions
required for JavaScriptKit to work. See [`README.md`](https://github.com/swiftwasm/JavaScriptKit#readme)
in the project repository for more details.

## Tokamak

Based on the improvements to JavaScriptKit and major work by our contributors, we're also tagging
a new 0.9.0 release of [Tokamak](https://github.com/TokamakUI/Tokamak), a SwiftUI-compatible
framework for building browser apps with WebAssembly. Namely, we've added:

- `Canvas` and `TimelineView` types;
- `onHover` modifier;
- `task` modifier for running `async` functions;
- Sanitizers for `Text` view.

This release now also requires Swift 5.4 as a minimum version, and Swift 5.5 (with SwiftWasm
5.5 when targeting the browser environment) is recommended.

## Acknowledgements

We'd like to thank [our sponsors](https://github.com/sponsors/swiftwasm) for their support, which
allowed us to continue working on SwiftWasm and related project.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of (in alphabetical order):

- [@agg23](https://github.com/agg23)
- [@carson-katri](https://github.com/carson-katri)
- [@ezraberch](https://github.com/ezraberch)
- [@Feuermurmel](https://github.com/Feuermurmel)
- [@kateinoigakukun](https://github.com/kateinoigakukun)
- [@MaxDesiatov](https://github.com/MaxDesiatov)
- [@mbrandonw](https://github.com/mbrandonw)
- [@PatrickPijnappel](https://github.com/PatrickPijnappel
- [@yonihemi](https://github.com/yonihemi/)
- all of our users, and everyone working on the Swift project and libraries we depend on!
