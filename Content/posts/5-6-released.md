---
date: 2022-04-28 10:10
description: SwiftWasm 5.6.0 has been released.
---

# SwiftWasm 5.6.0 is now available

We're happy to announce the new release of SwiftWasm tracking upstream Swift 5.6!

Swift 5.6 enhances the language through a number of proposals from the Swift Evolution process, including:

[SE-0290](https://github.com/apple/swift-evolution/blob/main/proposals/0290-negative-availability.md) - Unavailability Condition
[SE-0315](https://github.com/apple/swift-evolution/blob/main/proposals/0315-placeholder-types.md) - Type placeholders (formerly, “Placeholder types”)
[SE-0320](https://github.com/apple/swift-evolution/blob/main/proposals/0320-codingkeyrepresentable.md) - Allow coding of non String / Int keyed Dictionary into a KeyedContainer
[SE-0322](https://github.com/apple/swift-evolution/blob/main/proposals/0322-temporary-buffers.md) - Temporary uninitialized buffers
[SE-0324](https://github.com/apple/swift-evolution/blob/main/proposals/0324-c-lang-pointer-arg-conversion.md) - Relax diagnostics for pointer arguments to C functions
[SE-0331](https://github.com/apple/swift-evolution/blob/main/proposals/0331-remove-sendable-from-unsafepointer.md) - Remove Sendable conformance from unsafe pointer types
[SE-0335](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md) - Introduces existential any
[SE-0337](https://github.com/apple/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md) - Incremental migration to concurrency checking

## New JavaScriptKit runtime

The 0.14 release is a breaking release that enables full support for SwiftWasm 5.6 and lays groundwork for future updates to [DOMKit](https://github.com/swiftwasm/DOMKit/).

Specifically:

- The `ConvertibleToJSValue` conformance on `Array` and `Dictionary` has been swapped from the `== ConvertibleToJSValue` case to the `: ConvertibleToJSValue` case.
  - This means that e.g. `[String]` is now `ConvertibleToJSValue`, but `[ConvertibleToJSValue]` no longer conforms.
  - the `jsValue()` method still works in both cases.
  - to adapt existing code, use one of these approaches:
    - use generics where possible (for single-type arrays)
    - call `.map { $0.jsValue() }` (or `mapValues`) to get an array/dictionary of `JSValue` which you can then use as `ConvertibleToJSValue`
    - add `.jsValue` to the end of all of the values in the array/dictionary literal.

## Carton

The 0.14 release uses SwiftWasm 5.6.0 as the default toolchain. Additionally, issue with rebuilding projects when watching for file changes with carton dev has been fixed. Also, please refer to release details for carton 0.13.0 for more information on new recently introduced command-line flags.

Many thanks to [@kateinoigakukun](https://github.com/kateinoigakukun) for contributions!

## Acknowledgements

We'd like to thank [our sponsors](https://github.com/sponsors/swiftwasm) for their support, which
allowed us to continue working on SwiftWasm and related project.

Many thanks to [MacStadium](https://www.macstadium.com) for giving us access to Apple Silicon hardware.
Without their help it would be close to impossible to set up CI for enabling full M1 support in our toolchain.

Additionally, we'd like to thank everyone who contributed their work and helped us make this release
happen. These new releases wouldn't be possible without the hard work of (in alphabetical order):

- [@agg23](https://github.com/agg23)
- [@carson-katri](https://github.com/carson-katri)
- [@ezraberch](https://github.com/ezraberch)
- [@Feuermurmel](https://github.com/Feuermurmel)
- [@kateinoigakukun](https://github.com/kateinoigakukun)
- [@MaxDesiatov](https://github.com/MaxDesiatov)
- [@mbrandonw](https://github.com/mbrandonw)
- [@PatrickPijnappel](https://github.com/PatrickPijnappel)
- [@yonihemi](https://github.com/yonihemi/)
- all of our users, and everyone working on the Swift project and libraries we depend on!
