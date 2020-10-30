---
date: 2020-10-30 14:34
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
integrate binaries produced by SwiftWasm in a host application.

[@johngarrett](https://github.com/johngarrett) published an interactive ["Swift, Wasm, and
Algorithms"](https://garrepi.dev/swal) documentation page. It is a demo of the recently released
[Swift Algorithms](https://github.com/apple/swift-algorithms) package where you can tweak parameters
for some of the functions and observe results directly in the browser. Not all of the functions are
fully interactive now, but it's a great proof of concept for interactive documentation websites one
could build with SwiftWasm. Its source code is [available on
GitHub](https://github.com/johngarrett/swal-wasm).

## SwiftWasm documentation

Two new sections were added to [the SwiftWasm book](https://book.swiftwasm.org/) that clarify
[limitations of Foundation](https://book.swiftwasm.org/getting-started/foundation.html),
and [recommended ways to use XCTest](https://book.swiftwasm.org/getting-started/testing.html) with
the SwiftWasm SDK.

## Developer tools

### WasmTransformer

[@kateinoigakukun](https://github.com/kateinoigakukun) published [a pure Swift implementation of a
transformer for Wasm binaries](https://github.com/swiftwasm/WasmTransformer). This resolves
[the issue with `i64` to `BigInt` incompatibility in Safari](https://github.com/swiftwasm/JavaScriptKit/issues/97),
as we can now [integrate an appropriate transformation](https://github.com/swiftwasm/carton/pull/131)
into our build pipeline in `carton`. The `WasmTransformer` library is still at an early stage, but
it shows that Swift is suitable for low-level code just as well as C/C++ or Rust.

### `carton`

In addition to the WasmTransfomer integration mentioned above, `carton test` now [passes
the `--enable-test-discovery` flag](https://github.com/swiftwasm/carton/pull/130) to `swift test` by
default, which means that you no longer need to maintain `LinuxMain.swift` and `XCTestManifests.swift`
files in your test suites.

A `Dockerfile` [was added to the `carton` repository](https://github.com/swiftwasm/carton/pull/136),
and you can now run `carton` in a Docker container, which also has the toolchain and other
dependencies preinstalled. You can pull the Docker image with a simple command:

```
docker pull ghcr.io/swiftwasm/carton:latest
```

Additionally, `carton` gained [support for Ubuntu 20.04](https://github.com/swiftwasm/carton/pull/134),
and now also has a CI job to test compatibility with it during development. Similarly, [a CI job
for macOS Big Sur on Intel platforms](https://github.com/swiftwasm/carton/pull/132) was added as
soon as GitHub Actions started providing appropriate CI images.

After these changes were merged [`carton` 0.7 was released](https://github.com/swiftwasm/carton/releases/tag/0.7.0)
and is now available via Homebrew on macOS.

After the release, [@carson-katri](https://github.com/carson-katri) merged a PR that greatly improves
command-line experience with `carton test`. It builds on his previous work on `carton dev` with
compiler diagnostics parsing and error highlighting. With this new change XCTest output
is also parsed, reformatted, and highlighted in a nice summary view.

<br />

![Pretty-printed test summary in `carton`](/images/update-03-carton-test-summary.png width=100%)

<br />
<br />

![Pretty-printed test errors in `carton`](/images/update-03-carton-test-errors.png width=100%)

<br />
<br />

### GitHub Actions

Thanks to the fact that `carton` is now available in a Docker image, it can now be used in
our [`swiftwasm-action`](https://github.com/swiftwasm/swiftwasm-action), which previously only
contained the plain SwiftWasm toolchain without any additional tools. This action now
invokes `carton test` by default on a given repository during a GitHub Actions run, but you can
customize it and call any other command. For example, you could run `carton bundle` with `swiftwasm-action`,
and then use the [`peaceiris/actions-gh-pages`](https://github.com/peaceiris/actions-gh-pages) step
to deploy the resulting bundle to [GitHub Pages](https://pages.github.com/).

## Libraries

## JavaScriptKit

[JavaScriptKit 0.8.0](https://github.com/swiftwasm/JavaScriptKit/releases/tag/0.8.0) has been
released. As mentioned in our previous issue, it introduces a few enhancements and deprecations,
and is a recommended upgrade for all users.

### Tokamak

[@Cosmo](https://github.com/Cosmo) pointed out that SwiftUI apps should change almost the whole
palette when switching between color schemes. As he discovered when working on his
[OpenSwiftUI](https://github.com/Cosmo/OpenSwiftUI/) and [SwiftUIEmbedded](https://github.com/Cosmo/SwiftUIEmbedded)
projects, the implementation of the `Color` type is much more subtle than we originally anticipated.
This was resolved by [@carson-katri](https://github.com/carson-katri) in
[#291](https://github.com/TokamakUI/Tokamak/issues/291) and is now available in the `main` branch.
The plan is to merge a few more changes and bugfixes, and to tag a new release of Tokamak soon
after that.

## Upstream PRs

### Swift Driver

[@owenv](https://github.com/owenv) merged [a PR to the Swift Driver
project](https://github.com/apple/swift-driver/pull/315) implementing WebAssembly toolchain
support. This mirrors our existing [C++ implementation in the legacy
driver](https://github.com/swiftwasm/swift/blob/swiftwasm/lib/Driver/WebAssemblyToolChains.cpp), and
it's great that the new parts of the Swift compiler rewritten in Swift are going to support
WebAssembly too. While Swift Driver isn't enabled in any toolchain by default, we're definitely
going to enable it at some point in the future as soon as it seems to be stable enough for
us.

### SwiftPM and Swift Tools Support Core

[@kateinoigakukun](https://github.com/kateinoigakukun) submitted [a PR to
SwiftPM](https://github.com/apple/swift-package-manager/pull/3001) that propagates the `-static-stdlib`
flag correctly to the compiler driver. After it was merged, we were able [to remove a bit of
code](https://github.com/swiftwasm/carton/pull/141) that generated SwiftPM destination files to
ensure correct linking, and this is no longer needed thanks to the upstream changes.

[@MaxDesiatov](https://github.com/sponsors/MaxDesiatov) merged [a PR to Swift
TSC](https://github.com/apple/swift-tools-support-core/pull/153) that adds `.wasm` file extension to
WebAssembly binaries produced by SwiftPM. This extension was previously missing, which didn't make
it obvious enough that these binaries can't be run without passing them to an appropriate
WebAssembly host.

## Toolchain/SDK work

In preparation for the 5.3.0 release of SwiftWasm, our macOS archives are [now distributed as
signed `.pkg` installers](https://github.com/swiftwasm/swift/pull/2029). Also need to mention that
the toolchain archive is now available for Ubuntu 20.04, and all archive files now have consistent
naming that includes the full OS name and CPU architecture. This will make it much easier for us
to distribute ARM64 builds and builds for other Linux distributions in the
future.

[Another change](https://github.com/swiftwasm/swift/pull/2125) to be included in 5.3 snapshots would
add `.wasm` file extension to binaries reflecting aforementioned upstream PRs.

Additionally, we found that it's currently not possible to build C++ code that includes certain
headers with SwiftWasm 5.3 snapshots. As some Swift libraries do have C++ targets as their
dependencies, [it would be great if this is fixed](https://github.com/swiftwasm/swift/pull/2127)
before SwiftWasm 5.3.0 is tagged.

We'll be using latest 5.3 snapshots in our apps and libraries for some time, and will tag 5.3.0 when
we have enough confidence there are no major issues.

The `wasm-DEVELOPMENT-SNAPSHOT` archives will continue to be tagged on a regular basis to serve as
a preview of the next version of SwiftWasm, but are not recommended for general use.

## Contributions

A lot of the progress wouldn't be possible without payments from our GitHub Sponsors. Their
contribution is deeply appreciated and allows us to spend more time on SwiftWasm projects. You can
see the list of sponsors and make your contribution on the sponsorship pages of [Carson
Katri](https://github.com/sponsors/carson-katri), [Yuta
Saito](https://github.com/sponsors/kateinoigakukun) and [Max
Desiatov](https://github.com/sponsors/MaxDesiatov).

Thanks for reading! 👋
