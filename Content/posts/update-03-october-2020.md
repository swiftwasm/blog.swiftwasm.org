---
date: 2020-10-28 14:34
description: An update on what happened in the SwiftWasm ecosystem during the second half of October 2020.
---
# What's new in SwiftWasm #3

## Upstream PRs

### Swift Driver

[@owenv](https://github.com/owenv) submitted [a PR to the Swift Driver
project](https://github.com/apple/swift-driver/pull/315) implementing WebAssembly toolchain
support. This mirrors our existing [C++ implementation in the legacy
driver](https://github.com/swiftwasm/swift/blob/swiftwasm/lib/Driver/WebAssemblyToolChains.cpp), and
it's great that the new parts of the Swift compiler rewritten in Swift are going to support
WebAssembly too. While Swift Driver in that enabled in any toolchain by default, we're definitely
going to enable it at some point in the future as soon Swift Driver seems to be stable enough for
us.
