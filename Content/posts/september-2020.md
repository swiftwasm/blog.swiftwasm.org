---
date: 2020-09-30 14:34
description: An update on what happened in the SwiftWasm ecosystem during September 2020.
---
# September 2020 Update

Welcome to the SwiftWasm blog! The amount of work happening in [the SwiftWasm
ecosystem](https://github.com/swiftwasm) is growing, so we decided to start publishing blog updates
to give you an overview of what happened recently. This update for September is big enough to be
split into different sections for each area of our work, so let's get started. 🙂

## Libraries

[JavaScriptKit 0.7](https://github.com/swiftwasm/JavaScriptKit/releases/tag/0.7.0) has been
released. It adds multiple new types bridged from JavaScript,
namely `JSError`, `JSDate`, `JSTimer` (which corresponds to `setTimeout`/`setInterval` calls and
manages closure lifetime for you), `JSString` and `JSPromise`. We now also have [documentation
published automatically](https://swiftwasm.github.io/JavaScriptKit/) for the `main` branch.

New features of JavaScriptKit allowed us to start working on closer integration with
[OpenCombine](https://github.com/OpenCombine/OpenCombine). The current progress is available in the
new [OpenCombineJS](https://github.com/swiftwasm/OpenCombineJS) repository, and we plan to tag a
release for it soon. At the moment it has a `JSScheduler` class wrapping `JSTimer` that implements
[the `Scheduler` protocol](https://developer.apple.com/documentation/combine/scheduler), enabling
you to use `debounce` and other time-based operators. Additionally, OpenCombineJS now provides a
helper `publisher` property on `JSPromise`, which allows you to integrate any promise-based API with
an OpenCombine pipeline.

We also saw a lot of great progress with [DOMKit](https://github.com/swiftwasm/DOMKit) in September
thanks to the outstanding work by [Jed Fox](https://jedfox.com/) and
[@Unkaputtbar](https://github.com/Unkaputtbar), which was unblocked by the recent additions to
JavaScriptKit. With DOMKit we're going to get type-safe access to the most common browser DOM APIs.
It will be expanded in the future to support even more features that currently are only available
via JavaScriptKit through force unwrapping and dynamic casting.

That is, compare the current API you get with JavaScriptKit:

```swift
import JavaScriptKit

let document = JSObject.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)
```

to an equivalent snippet that could look like this with DOMKit:

```swift
import DOMKit

let document = global.document

let divElement = document.createElement("div")
divElement.innerText = "Hello, world"
document.body.appendChild(divElement)
```

Lastly on the libraries front, [Tokamak 0.4](https://github.com/TokamakUI/Tokamak/releases) is now
available, enabling compatibility with the new version of JavaScriptKit, and utilizing the
aforementioned `JSScheduler` implementation.

## Developer tools

Following the new 0.7 release of JavaScriptKit, [`carton`
0.6](https://github.com/swiftwasm/carton/releases/tag/0.6.0) has been tagged, shipping with the
appropriate JavaScriptKit runtime compatible with the new release. It also includes support for the
new `carton bundle` command that produces a directory with optimized build output ready for
deployment on a CDN or any other server. Notably, both `carton bundle` and `carton dev` support
[SwiftPM package
resources](https://github.com/apple/swift-evolution/blob/master/proposals/0271-package-manager-resources.md),
allowing you to include additional static content in your SwiftWasm apps. These could be styles,
scripts, images, fonts, or whatever other data you'd like to ship with your app.

This version of `carton` also ships with the latest version of
[wasmer.js](https://github.com/wasmerio/wasmer-js/), which fixes compatibility with 
recently released Safari 14.

## Toolchain/SDK work

The upstream Swift toolchain has switched to [LLVM](http://llvm.org) 11 in the `main` branch,
which caused a substantial amount of conflicts in our forked repositories. Resolving the conflicts
and making sure everything builds properly consumed a lot of our time in September.
You could've noticed that the previously steady stream of nighly development snapshots stalled for
most of September, but it resumed starting with `wasm-DEVELOPMENT-SNAPSHOT-2020-09-20-a`.

As for the 5.3 branch, with the upstream Swift 5.3.0 release now generally available, we're
now preparing a stable SwiftWasm 5.3.0 release. It is based off upstream 5.3.0
with our patches applied to the toolchain and the SDK. [We've created a
checklist](https://github.com/swiftwasm/swift/issues/1759) that allows us to track the
progress of this effort.

One of the issues we wanted to resolve before tagging SwiftWasm 5.3.0 is the inconsistency between
WASI and Glibc APIs. While parts of those look and works the same, the rest are significantly 
different. Because of this, in subsequent snapshots our users need to use `import WASILibc` instead
of `import Glibc` if they need to access to libc on the WASI platform. This has already landed in
the `swiftwasm-release/5.3` branch with [swiftwasm/swift#1773](https://github.com/swiftwasm/swift/pull/1773)
and is available in `wasm-5.3-SNAPSHOT-2020-09-23-a` or later. It was also implemented in the 
main `swiftwasm` branch in [swiftwasm/swift#1832](https://github.com/swiftwasm/swift/pull/1832), all
thanks to the amazing work by [Yuta Saito](https://github.com/sponsors/kateinoigakukun).

## Upstream PRs

The divergence between the SwiftWasm toolchain/SDKs and their upstream version is still significant
and causes regular conflicts that we have to resolve manually. We're working on making our changes
available upstream, but this takes a lot of time, as upstream toolchain and SDK PRs need high level of
polish to be accepted. Here's a list of PRs that had some progress in September:

### Foundation

* Add locking primitives for `TARGET_OS_WASI` in `CFLocking.h`
  [apple/swift-corelibs-foundation#2867](https://github.com/apple/swift-corelibs-foundation/pull/2867).
  **Status: merged.**
* Add support for WASI in `CFInternal.h`
  [apple/swift-corelibs-foundation#2872](https://github.com/apple/swift-corelibs-foundation/pull/2872).
  **Status: merged.**
* Add WASI support in `CoreFoundation_Prefix.h`
  [apple/swift-corelibs-foundation#2873](https://github.com/apple/swift-corelibs-foundation/pull/2873).
  **Status: merged.**
* Add support for WASI in `CFDate.c`
  [apple/swift-corelibs-foundation#2880](https://github.com/apple/swift-corelibs-foundation/pull/2880).
  **Status: in review.**

### SwiftPM

* Propagate PATH to UserToolchain to fix sysroot search
  [apple/swift-package-manager#2936](https://github.com/apple/swift-package-manager/pull/2936).
  **Status: merged.**

## Contributions

We hope you can contribute to the SwiftWasm ecosystem, either to any of the projects listed above,
or with your own libraries and apps that you built. We'd be very happy to feature your open-source
work in our next update! Our [`swiftwasm.org` website](https://github.com/swiftwasm/swiftwasm.org)
and [this blog](https://github.com/swiftwasm/blog.swiftwasm.org) are open-source, so please feel
free to open an issue or a pull request with a link to your work related to SwiftWasm.

A lot of the progress wouldn't be possible without payments from our GitHub Sponsors. Their
contribution is deeply appreciated and allows us to spend more time on SwiftWasm projects. You can
see the list of sponsors and make your contribution on the sponsorship pages of [Yuta
Saito](https://github.com/sponsors/kateinoigakukun) and [Max
Desiatov](https://github.com/sponsors/MaxDesiatov).

Thanks for reading! 👋
