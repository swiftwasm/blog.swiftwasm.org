---
date: 2024-06-14 20:00
description: SwiftWasm 5.10 has been released.
---

# SwiftWasm 5.10 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.10!

[swift-wasm-5.10.0-RELEASE](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-5.10.0-RELEASE)

This is a periodic release of SwiftWasm, which tracks the upstream Swift 5.10 release.
As for changes in upstream Swift 5.10, we recommend referring [to the official
changelog](https://github.com/apple/swift/blob/swift-5.10-RELEASE/CHANGELOG.md#swift-510).

For more information about SwiftWasm in general and for getting started, please visit [the project documentation](https://book.swiftwasm.org/).
If you have any questions, please come and talk to us on [the SwiftWasm discussion forums](https://github.com/swiftwasm/swift/discussions)
or [open an issue](https://github.com/swiftwasm/swift/issues/new)!

## Reduced differences with the upstream

In this release, we've worked on upstreaming our changes to the Swift project, and the number of patches we maintain has been significantly reduced (from 58 to 19!) compared to the previous 5.9 release.

Looking ahead to the 6.0 release, we've already completed all the upstreaming work, meaning that the compiler and standard library sources are now completely in sync with the official Swift repository. Stay tuned for the upcoming releases!


## Acknowledgements

We'd like to thank [our GitHub sponsors](https://github.com/sponsors/swiftwasm) and [OpenCollective
contributors](https://opencollective.com/swiftwasm) for their support, which allowed us to continue working on SwiftWasm
and related projects. We are displaying our gold sponsors on the README of [swiftwasm/swift](https://github.com/swiftwasm/swift) repository.
If you are already a gold sponsor and not yet listed, please [contact Yuta Saito](https://twitter.com/kateinoigakukun) to add your appropriate logo.

We're committed to publishing transparent and open finances, so all expenses and transactions can be
viewed publicly on our [OpenCollective Transactions](https://opencollective.com/swiftwasm/transactions) page.

So far we've spent money on monthly CI bills that cover new `aarch64` CPU architecture and [community CI](https://ci-external.swift.org/job/oss-swift-RA-linux-ubuntu-20.04-webassembly),
domain registration, email hosting, and development hardware for our maintainers.

Many thanks to [MacStadium](https://www.macstadium.com) for giving us access to Apple Silicon hardware.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of them and the Swift community as a whole.
