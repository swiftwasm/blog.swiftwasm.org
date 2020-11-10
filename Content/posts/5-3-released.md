---
date: 2020-11-10 0:39
description: The first stable toolchain release of SwifWasm!
---

# The first stable toolchain release of SwifWasm!

## Overview 

This is the [first public release](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-5.3.0-RELEASE) of SwiftWasm toolchain, available as a signed .pkg installer for macOS. Also via swiftenv-compatible archives and Docker for Intel-based Ubuntu 18.04 and 20.04.
Our focus is on providing essential Swift features for the WebAssembly platform. Distributions supplied with this release are our most stable yet, and no breaking changes are expected for 5.3 releases anymore.


This release includes the Swift for WebAssembly compiler, the standard and core libraries (excluding Dispatch), JavaScript interoperation library, UI library, build tool and CI support.


## The standard library and core libraries

The Swift standard library is fully available on WebAssembly platform.

The standard library right now depends on WASI, which is a modular system interface for WebAssembly. We use the [wasi-libc](https://github.com/WebAssembly/wasi-libc) implementation, which you can also use in your Swift apps with a simple `import WASILibc` statement.
However, we are going to make the WASI dependency optional in the future.


### Foundation / XCTest

Foundation and XCTest are also available on WebAssembly, but in a limited capacity.

Please refer to our [Foundation](https://book.swiftwasm.org/getting-started/foundation.html) and [XCTest](https://book.swiftwasm.org/getting-started/testing.html) guides for more details.


## JavaScript interoperation library

[JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) is a Swift library to interact with JavaScript through WebAssembly.

You can use any JavaScript API from Swift with this library. Here's a quick example of JavaScriptKit usage in a browser app:

```swift
import JavaScriptKit

let document = JSObject.global.document

var divElement = document.createElement("div")
divElement.innerText = "Hello, world"
_ = document.body.appendChild(divElement)
```

You can learn more from our [JavaScript interop guide](https://book.swiftwasm.org/getting-started/javascript-interop.html).


## UI library

[The Tokamak UI framework](https://tokamak.dev) is a cross-platform implementation of the SwiftUI API. We currently only support WebAssembly/DOM with a lot of API parts covered, and static HTML rendering on macOS/Linux. Get started with our [browser apps guide](https://book.swiftwasm.org/getting-started/browser-app.html) that lists necessary steps to create a simple browser app with Tokamak.

## All-in-one builder, test runner, and bundler for SwiftWasm

[`carton`](https://github.com/swiftwasm/carton) is a build tool designed specifically for SwiftWasm. It is similar to webpack.js, but no configuration and dependencies (except Swift itself to build `carton`) are required. It's also our recommended way to install SwiftWasm as it downloads and unpacks our toolchain and SDK automatically for you.

## CI support

We maintain a [GitHub Action](https://github.com/swiftwasm/swiftwasm-action) that includes the SwiftWasm toolchain and `carton`  for your continuous integration needs.
