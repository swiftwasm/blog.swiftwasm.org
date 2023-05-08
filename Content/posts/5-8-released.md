---
date: 2023-05-08 10:10
description: SwiftWasm 5.8.0 has been released.
---

# SwiftWasm 5.8.0 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.8!

Notable WebAssembly-specific changes in this release:

- The toolchain is now available for Ubuntu 22.04 on the `x86_64` architecture. (Note that `aarch64` support is available only for macOS and Ubuntu 20.04 for now.)
- Support for [Distributed Actors](https://github.com/apple/swift-evolution/blob/main/proposals/0336-distributed-actor-isolation.md) on WebAssembly was added.
- The `ghcr.io/swiftwasm/swift` Docker image is now based on Ubuntu 22.04 by default for `latest` and `5.8` tags.

As for changes in upstream Swift 5.8, we recommend referring [to the official
changelog](https://github.com/apple/swift/blob/release/5.8/CHANGELOG.md#swift-58).

For more information about SwiftWasm in general and for getting started, please visit [the project documentation](https://book.swiftwasm.org/).
If you have any questions, please come and talk to us on [the SwiftWasm discussion forums](https://github.com/swiftwasm/swift/discussions)
or [open an issue](https://github.com/swiftwasm/swift/issues/new)!

## Acknowledgements

We'd like to thank [our GitHub sponsors](https://github.com/sponsors/swiftwasm) and [OpenCollective
contributors](https://opencollective.com/swiftwasm) for their support, which allowed us to continue working on SwiftWasm
and related projects.

We're committed to publishing transparent and open finances, so all expenses and transactions can be
viewed publicly on our [OpenCollective Transactions](https://opencollective.com/swiftwasm/transactions) page.

So far we've spent money on monthly CI bills that cover new `aarch64` CPU architecture and [community CI](https://ci-external.swift.org/job/oss-swift-RA-linux-ubuntu-20.04-webassembly),
domain registration, email hosting, and development hardware for our maintainers.

Many thanks to [MacStadium](https://www.macstadium.com) for giving us access to Apple Silicon hardware.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of them and the Swift community as a whole.


## About the last release

We forgot to announce the [last release of SwiftWasm 5.7](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-5.7.3-RELEASE) in this blog, so here's a quick summary of what was included in
that release:

- The Foundation and XCTest core libraries were shipped without release optimizations.
  [Now they're built with release optimizations enabled](https://github.com/swiftwasm/swift/pull/4355), which should improve performance of SwiftWasm apps.
- Support for [duration-based `Task.sleep`](https://github.com/apple/swift-evolution/blob/main/proposals/0329-clock-instant-duration.md) was added.

