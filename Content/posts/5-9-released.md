---
date: 2024-01-16 20:00
description: SwiftWasm 5.9.1 has been released.
---

# SwiftWasm 5.9.1 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.9!

This is a periodic release of SwiftWasm, which tracks the upstream Swift 5.9 release.
As for changes in upstream Swift 5.9, we recommend referring [to the official
changelog](https://github.com/apple/swift/blob/swift-5.9.1-RELEASE/CHANGELOG.md#swift-59).

For more information about SwiftWasm in general and for getting started, please visit [the project documentation](https://book.swiftwasm.org/).
If you have any questions, please come and talk to us on [the SwiftWasm discussion forums](https://github.com/swiftwasm/swift/discussions)
or [open an issue](https://github.com/swiftwasm/swift/issues/new)!

## Internal build infrastructure changes

We've made some changes to our internal build infrastructure, which should make it easier for us to
track upstream Swift changes. Now GitHub [swiftwasm/swift](https://github.com/swiftwasm/swift) repository
is just for hosting our release artifacts, and we're maintaining our downstream changes in traditional `.patch`
file format in [swiftwasm/swiftwasm-build](https://github.com/swiftwasm/swiftwasm-build) repository. See [our rationale](https://github.com/swiftwasm/swiftwasm-build/blob/main/docs/faq.md) if you're interested in the details of this decision.

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
