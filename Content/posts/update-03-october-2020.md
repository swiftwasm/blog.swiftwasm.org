---
date: 2020-10-28 14:34
description: An update on what happened in the SwiftWasm ecosystem during the second half of October 2020.
---
# What's new in SwiftWasm #3

## Examples and guides

[@hassan-shahbazi](https://github.com/hassan-shahbazi) wrote [a 3 part
guide](https://medium.com/@h.shahbazi/the-power-of-swift-web-assembly-part-1-fdfa4e9134ee) about
his experience when integrating SwiftWasm apps within Go apps through [Wasmer](https://wasmer.io/).
He also published [example code accompanying the
articles](https://github.com/hassan-shahbazi/swiftwasm-go) on GitHub. It's a great introduction
to SwiftWasm that doesn't assume much prior knowledge, and could be useful if you'd like to
integrate binaries produced by SwiftWasm in any host application.

## Libraries

### Tokamak

[@Cosmo](https://github.com/Cosmo) pointed out that SwiftUI apps should change almost the whole
palette when switching between color schemes. As he discovered when working on his
[OpenSwiftUI](https://github.com/Cosmo/OpenSwiftUI/) and [SwiftUIEmbedded](https://github.com/Cosmo/SwiftUIEmbedded)
projects, the implementation of the `Color` type is much more subtle than we originally anticipated.
This is now [tracked in the Tokamak repository](https://github.com/TokamakUI/Tokamak/issues/290) and
will help us a lot in our goal to track the SwiftUI behavior as closely as possible.

## Upstream PRs

### Swift Driver

[@owenv](https://github.com/owenv) merged [a PR to the Swift Driver
project](https://github.com/apple/swift-driver/pull/315) implementing WebAssembly toolchain
support. This mirrors our existing [C++ implementation in the legacy
driver](https://github.com/swiftwasm/swift/blob/swiftwasm/lib/Driver/WebAssemblyToolChains.cpp), and
it's great that the new parts of the Swift compiler rewritten in Swift are going to support
WebAssembly too. While Swift Driver in that enabled in any toolchain by default, we're definitely
going to enable it at some point in the future as soon Swift Driver seems to be stable enough for
us.
