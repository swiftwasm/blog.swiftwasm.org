---
date: 2025-04-07 10:10
description: SwiftWasm 6.1.0 has been released.
---

# SwiftWasm 6.1.0 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 6.1!

As for changes in upstream Swift 6.1, we recommend referring [to the official changelog](https://github.com/apple/swift/blob/release/6.1/CHANGELOG.md).

## Major Milestones

### First Release With No Custom Patches

This is the first stable release we've built directly from the official [swiftlang/swift](https://github.com/swiftlang/swift) source without any custom patches. This means all components (compiler, stdlib, Foundation, XCTest, swift-testing, etc.) have been fully upstreamed. You can verify this by checking our [release-6.1 build scheme](https://github.com/swiftwasm/swiftwasm-build/tree/main/schemes/release-6.1), which contains no patch files.

### Swift SDK-only Distribution

We've transitioned away from distributing compiler toolchains, and now exclusively distribute Swift SDKs. This allows you to use the official Swift toolchains from [swift.org](https://swift.org) together with our Swift SDK. The benefits are twofold:

- For users: You no longer need to install two separate compilers, saving disk space
- For maintainers: Our maintenance is significantly simplified as we don't need to build and distribute platform-specific compilers

## New Features

### Swift Testing Support

The Swift SDK now includes [swift-testing](https://github.com/swiftwasm/swift/issues/5587), providing access to the new testing framework. See [swiftlang/swift-testing#584](https://github.com/swiftlang/swift-testing/pull/584) for more details.
(Note that it's not yet included in the wasm32-unknown-wasip1-threads target for minor remaining works)

We'd like to extend special thanks to Jonathan Grynspan, who was incredibly supportive and friendly toward platform compatibility efforts, which made adding Swift Testing support for WebAssembly much smoother than it would have been otherwise.

### Code Coverage Support

Prior to this release, WebAssembly/WASI targets did not have any code coverage support in LLVM itself. We contributed some upstream work to LLVM ([PR #111332](https://github.com/llvm/llvm-project/pull/111332)) to enable this feature, including:

1. Porting `compiler-rt/lib/profile` to WebAssembly/WASI
2. Adjusting profile metadata sections and tools for the Wasm object file format

With this foundation in place, code coverage support is now available in Swift + WebAssembly projects ([Issue #5591](https://github.com/swiftwasm/swift/issues/5591)). You can now use the standard SwiftPM code coverage `--enable-code-coverage` flag to generate coverage data and LLVM tools to process them.

<img src="/images/6.1-release-coverage-support.png" alt="HTML report of JavaScriptKit test coverage" width="80%" />

### VSCode Support

VSCode + sourcekit-lsp setup is now supported with the Swift SDK, making the development experience smoother. See our [VSCode setup guide](https://book.swiftwasm.org/getting-started/vscode.html) for details.

<img src="/images/6.1-vscode-editing.png" alt="Editing Swift file with VSCode" width="80%" />

## Getting Started

For more information about SwiftWasm in general and for getting started, please visit [the project documentation](https://book.swiftwasm.org/).

If you have any questions, please come and talk to us on [the SwiftWasm discussion forums](https://github.com/swiftwasm/swift/discussions)
or [open an issue](https://github.com/swiftwasm/swift/issues/new)!

## Known Issues

There is a minor issue where you might encounter an error message about `archive member 'FoundationInternationalization.autolink' is neither Wasm object file nor LLVM bitcode` ([Issue #5596](https://github.com/swiftwasm/swift/issues/5596)). This has already been fixed in nightly builds via [swift-driver#1736](https://github.com/swiftlang/swift-driver/pull/1736) and is not a critical issue. You can safely continue using the SDK without worrying about this error message.

## What's Next

As we look forward, our focus includes:

- **Officialization**: Working with the upstream people to formally recognize WebAssembly as a supported platform. See the pitch post: [A Vision for WebAssembly Support in Swift](https://forums.swift.org/t/pitch-a-vision-for-webassembly-support-in-swift/79060).
- **JavaScript Interoperability**: Enhancing the integration between Swift and JavaScript ecosystems.
- **Performance Improvements**: Optimizing binary size, startup time, and runtime performance.
- **Component Model & WASI Preview 2**: Preparing for next-generation WebAssembly standards.

## Acknowledgements

We'd like to thank [our GitHub sponsors](https://github.com/sponsors/swiftwasm) and [OpenCollective
contributors](https://opencollective.com/swiftwasm) for their support, which allowed us to continue working on SwiftWasm
and related projects.

We're committed to publishing transparent and open finances, so all expenses and transactions can be
viewed publicly on our [OpenCollective Transactions](https://opencollective.com/swiftwasm/transactions) page.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of the contributors and the Swift community as a whole. 
