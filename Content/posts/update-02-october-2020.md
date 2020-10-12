---
date: 2020-10-14 14:34
description: An update on what happened in the SwiftWasm ecosystem during the first half of October 2020.
---
# What's new in SwiftWasm #2

Welcome to the second SwiftWasm update! To make the updates flow steady, we're trying to publish
them fortnightly now. Let us know what you think of this new cadence. And here's a gentle reminder
that this blog is fully open-source, so if you spot a typo, an error, a broken link, or have any
other feedback, please feel free to file it [in our `blog.swiftwasm.org` GitHub
repository](https://github.com/swiftwasm/blog.swiftwasm.org).

## SwiftWasm Team Updates

We would like to welcome [@yonihemi](https://github.com/yonihemi) to the SwiftWasm team who joined
us in the beginning of October. After the previous contributions he made to
[`carton`](https://carton.dev) it made perfect sense to expand our team. As always, we invite
everyone to contribute to any of our repositories, and it doesn't require much prior experience with
SwiftWasm if any at all. Bug fixes, feature additions, improved documentation and related changes
are very much appreciated and allow our ecosystem to grow even more!

## JavaScriptKit

[JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) had a few important updates in October
so far. Most importantly, now that [#91](https://github.com/swiftwasm/JavaScriptKit/pull/91) by
[@kateinoigakukun](https://github.com/kateinoigakukun) was merged, JavaScriptKit no longer uses
unsafe flags in its `Package.swift`. The use of unsafe flags was a big problem for us, as it breaks
dependency resolution due to strict checks that SwiftPM applies. If any package in your dependency
tree contains unsafe flags, you can no longer depend on its semantic version, or a semantic version
of any other package that depends on it.

So far we were able to work around that with a hardcoded check for JavaScriptKit in our fork of
SwiftPM. This was obviously a very ugly hack, but the biggest downside of that approach was that
you couldn't depend on any package that had a semantic version dependency on JavaScriptKit in
upstream Swift toolchains. That meant that libraries like [Tokamak](https://tokamak.dev) could not
be built for macOS or Linux. And while the WebAssembly DOM renderer in Tokamak is the most useful
module right now, this prevented us from working static HTML rendering in Tokamak on macOS and
Linux.

Another issue we had with JavaScriptKit is [the naming of `JSValueConstructible` and
`JSValueConvertible`](https://github.com/swiftwasm/JavaScriptKit/issues/87) protocols. These
protocols are used for conversions between `JSValue` references and arbitrary Swift values. In
practice it wasn't always clear which of these protocols was responsible for a specific conversion.
After some deliberation, these were renamed to `ConstructibleFromJSValue` and `ConvertibleToJSValue`
respectively in [#88](https://github.com/swiftwasm/JavaScriptKit/pull/88).

[An issue was raised](https://github.com/swiftwasm/JavaScriptKit/issues/97) by
[@yonihemi](https://github.com/yonihemi) this week on our JavaScriptKit repository about `i64`
Wasm function return type support in Safari. The reason for it is that [Safari is the only major
browser](https://webassembly.org/roadmap/) that doesn't support
[Wasm `i64` to `BigInt` conversion](https://github.com/WebAssembly/JS-BigInt-integration).
Unfortunately, there are many APIs that require this conversion to work, and it's unclear
yet if this can be polyfilled on the JavaScript side at all. Currently it looks like we need to
apply some transformations to binaries produced by SwiftWasm to resolve this issue, but it remains
to be seen how well that would work in practice.

## Tokamak

Tokamak didn't see major updates recently, but we've received some important bug reports during
the last few weeks. Firstly, there's [an edge case with `Picker`
views
view](https://github.com/TokamakUI/Tokamak/issues/285) that use `\.self` as an identifier keypath.
Secondly, [`Toggle` binding is not reset](https://github.com/TokamakUI/Tokamak/issues/287) after its
value changes outside of the view. Many thanks to [@rbartolome](https://github.com/rbartolome) for
the extensive testing he's given and for reporting these issues!

## Developer tools

In the first half of October [@yonihemi](https://github.com/yonihemi) submitted two important
quality-of-life improvements to `carton`:

* Allow changing dev server's port ([#116](https://github.com/swiftwasm/carton/pull/116)).
* Automatically open a browser window when dev server starts
([#117](https://github.com/swiftwasm/carton/pull/117)).

There's also an open "Pretty print diagnostics" PR [#112](https://github.com/swiftwasm/carton/pull/122)
submitted by [@carson-katri](https://github.com/carson-katri). It does some magic with diagnostic
messages emitted by the Swift compiler, highlights relevant lines of code and formats all of it
nicely. Arguably, this is going to be one of the best command-line build tool experiences I've seen.
You can check out a preview on this screenshot:

![Pretty-print compiler diagnostics in `carton`](./update-02-carton.png)

## Toolchain/SDK work


## Upstream PRs


### SourceKit-LSP

## Contributions

A lot of the progress wouldn't be possible without payments from our GitHub Sponsors. Their
contribution is deeply appreciated and allows us to spend more time on SwiftWasm projects. You can
see the list of sponsors and make your contribution on the sponsorship pages of [Carson
Katri](https://github.com/sponsors/carson-katri), [Yuta
Saito](https://github.com/sponsors/kateinoigakukun) and [Max
Desiatov](https://github.com/sponsors/MaxDesiatov).

Thanks for reading! 👋
