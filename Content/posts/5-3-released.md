---
date: 2020-11-10 0:39
description: The first stable toolchain release of SwifWasm!
---

# The first stable toolchain release of SwifWasm!

## Overview 

This is the first public release of SwiftWasm toolchain, available as a signed .pkg installer for macOS. Also via swiftenv-compatible archives and Docker for Intel-based Ubuntu 18.04 and 20.04.
The focus is providing the basic and stable Swift features on WebAssembly platform.


This release includes the Swift for WebAssembly compiler, the standard and core libraries, JavaScript interoperation library, UI library, build tool and CI supports.


## The standard library and core libraries

The Swift standard library is fully available on WebAssembly platform.

The standard library now depends on WASI, which is a modular system interface for WebAssembly, to build the stdlib upon [wasi-libc](https://github.com/WebAssembly/wasi-libc).
However, we are going to make the WASI dependency optional.


### Foundation / XCTest

Foundation and XCTest are also available on WebAssembly, but in a limited capacity.

You can learn more from our documentation:

- https://book.swiftwasm.org/getting-started/foundation.html
- https://book.swiftwasm.org/getting-started/testing.html


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

You can learn more from https://book.swiftwasm.org/getting-started/javascript-interop.html


## UI library

[the Tokamak UI framework](https://tokamak.dev) is a cross-platform implementation of the SwiftUI API. We currently only support WebAssembly/DOM with a lot of API parts covered, and static HTML rendering on macOS/Linux.



You can get started with here https://book.swiftwasm.org/getting-started/browser-app.html



## Build and bundle tool

[carton](https://github.com/swiftwasm/carton) is a build tool designed specifically for SwiftWasm. It's like webpack.js, but no configuration and dependencies (except Swift itself to build carton) are required. And it's probably the easiest way to install SwiftWasm, because it install the toolchain/SDK automatically

## CI supports

SwiftWasm project also provides a [GitHub Action](https://github.com/swiftwasm/swiftwasm-action) to build with SwiftWasm toolchain on continuous integration.

