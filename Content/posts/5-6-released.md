---
date: 2022-05-02 10:10
description: SwiftWasm 5.6.0 has been released.
---

# SwiftWasm 5.6.0 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.6!

Notable WebAssembly-specific changes in this release:

- The toolchain is now available for Ubuntu 20.04 on `aarch64` and Amazon Linux 2 on `x86_64` architectures.
- Updated WASI SDK with support for ["reactor" and "command" execution
  models](https://github.com/WebAssembly/WASI/issues/13). You should be using "reactor" model for event-based (browser)
  applications, while "command" mode is suitable for command-line applications. 

With 5.6 release, when building SwiftWasm apps manually with `swift build`, you should
pass `-Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor` flags to enable the "reactor" mode. When building with `carton`,
"reactor" model is enabled automatically.

As for changes in upstream Swift 5.6, we recommend referring [to the official
changelog](https://github.com/apple/swift/blob/release/5.6/CHANGELOG.md#swift-56). For convenience, here are some of the Swift
Evolution proposals included in the release:

- [SE-0290](https://github.com/apple/swift-evolution/blob/main/proposals/0290-negative-availability.md) - Unavailability Condition
- [SE-0305](https://github.com/apple/swift-evolution/blob/main/proposals/0305-swiftpm-binary-target-improvements.md) - Package Manager Binary Target Improvements
- [SE-0315](https://github.com/apple/swift-evolution/blob/main/proposals/0315-placeholder-types.md) - Type placeholders (formerly, “Placeholder types”)
- [SE-0320](https://github.com/apple/swift-evolution/blob/main/proposals/0320-codingkeyrepresentable.md) - Allow coding of non `String`/`Int` keyed `Dictionary` into a `KeyedContainer`
- [SE-0322](https://github.com/apple/swift-evolution/blob/main/proposals/0322-temporary-buffers.md) - Temporary uninitialized buffers
- [SE-0324](https://github.com/apple/swift-evolution/blob/main/proposals/0324-c-lang-pointer-arg-conversion.md) - Relax diagnostics for pointer arguments to C functions
- [SE-0325](https://github.com/apple/swift-evolution/blob/main/proposals/0325-swiftpm-additional-plugin-apis.md) - Additional Package Plugin APIs
- [SE-0331](https://github.com/apple/swift-evolution/blob/main/proposals/0331-remove-sendable-from-unsafepointer.md) - Remove `Sendable` conformance from unsafe pointer types
- [SE-0332](https://github.com/apple/swift-evolution/blob/main/proposals/0332-swiftpm-command-plugins.md) - Package Manager Command Plugins
- [SE-0335](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md) - Introduces existential `any`
- [SE-0337](https://github.com/apple/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md) - Incremental migration to concurrency checking

## New JavaScriptKit runtime

[JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) 0.14 is a breaking release that enables full support for SwiftWasm 5.6 and lays groundwork for [future
updates](https://github.com/swiftwasm/DOMKit/pull/10) to [DOMKit](https://github.com/swiftwasm/DOMKit/).

Specifically, the `ConvertibleToJSValue` conformance on `Array` and `Dictionary` has been swapped from the
equality `== ConvertibleToJSValue` clause to the inheritance `: ConvertibleToJSValue` clause.

- This means that e.g. `[String]` is now `ConvertibleToJSValue`, but `[ConvertibleToJSValue]` no longer conforms.
- the `jsValue()` method still works in both cases.
- to adapt existing code, use one of these approaches:
  - use generics where possible (for single-type arrays)
  - call `.map { $0.jsValue() }` (or `mapValues`) to get an array/dictionary of `JSValue` which you can then use as
    `ConvertibleToJSValue`
  - add `.jsValue` to the end of all values in an array/dictionary literal.

## carton

The 0.14 release of [`carton`](https://carton.dev) uses SwiftWasm 5.6.0 as the default toolchain. Additionally, issue with rebuilding projects
when watching for file changes with `carton dev` has been fixed. Also, please refer to [release details for `carton`
0.13.0](https://github.com/swiftwasm/carton/releases/tag/0.13.0) for more information on new recently
introduced `--debug-info` and `-Xswiftc` command-line flags.

## Tokamak

[Tokamak](https://tokamak.dev) 0.10.0 adds support for SwiftWasm 5.6. It also updates JavaScriptKit and OpenCombineJS
dependencies. Due to issues with support for older SwiftWasm releases in the carton/SwiftPM integration, Tokamak now
requires SwiftWasm 5.6 or later, while SwiftWasm 5.4 and 5.5 are no longer supported.

## OpenCollective Budget

As may already know, [our OpenCollective page](https://opencollective.com/swiftwasm) is the main way to financially
support us. We're committed to publishing transparent and open finances, so we are excited to announce that all
expenses and transactions can be viewed publicly on our [OpenCollective
Transactions](https://opencollective.com/swiftwasm/transactions) page.

So far we've spent money on monthly CI bills that cover new `aarch64` CPU architecture and Linux distributions, 
domain registration, email hosting, and development hardware for our maintainers.

## Acknowledgements

We'd like to thank [our GitHub sponsors](https://github.com/sponsors/swiftwasm) and [OpenCollective
contributors](https://opencollective.com/swiftwasm) for their support, which allowed us to continue working on SwiftWasm
and related projects.

Many thanks to [MacStadium](https://www.macstadium.com) for giving us access to Apple Silicon hardware.
Without their help it would be close to impossible to set up CI for enabling full M1 support in our toolchain.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of (in alphabetical order):

- [@andrewbarba](https://github.com/andrewbarba)
- [@carson-katri](https://github.com/carson-katri)
- [@ezraberch](https://github.com/ezraberch)
- [@fjtrujy](https://github.com/fjtrujy)
- [@j-f1](https://github.com/j-f1)
- [@kateinoigakukun](https://github.com/kateinoigakukun)
- [@MaxDesiatov](https://github.com/MaxDesiatov)
- [@pedrovgs](https://github.com/pedrovgs)
- [@SDGGiesbrecht](https://github.com/SDGGiesbrecht)
- [@SwiftCoderJoe](https://github.com/SwiftCoderJoe)
- [@yonihemi](https://github.com/yonihemi/)

...and to all of our users, and everyone working on the Swift project and libraries we depend on!
