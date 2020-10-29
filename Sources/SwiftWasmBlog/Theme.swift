/**
 *  Publish
 *  Copyright (c) John Sundell 2019
 *  MIT license, see LICENSE file for details
 */

import Foundation
import Plot
import Publish

private let dateFormatter: DateFormatter = {
  let result = DateFormatter()
  result.dateStyle = .long
  result.timeStyle = .none
  return result
}()

extension Theme {
  /// The default "Foundation" theme that Publish ships with, a very
  /// basic theme mostly implemented for demonstration purposes.
  static var swiftwasm: Self {
    Theme(
      htmlFactory: Factory(),
      resourcePaths: ["Resources/styles.css", "Resources/splash.css"]
    )
  }
}

private struct Factory<Site: Website>: HTMLFactory {
  func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
    .page(for: index, context, body:
      .header(for: context, selectedSection: nil),
      .wrapper(
        .h1(.text(index.title)),
        .p(
          .class("description"),
          .text(context.site.description)
        ),
        .h2("Latest content"),
        .itemList(
          for: context.allItems(
            sortedBy: \.date,
            order: .descending
          ),
          on: context.site
        )
      ),
      .footer(for: context.site))
  }

  func makeSectionHTML(
    for section: Section<Site>,
    context: PublishingContext<Site>
  ) throws -> HTML {
    .page(for: section, context, body:
      .header(for: context, selectedSection: section.id),
      .wrapper(
        .h1(.text(section.title)),
        .itemList(for: section.items, on: context.site)
      ),
      .footer(for: context.site))
  }

  func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
    .page(for: item, context, body:
      .class("item-page"),
      .header(for: context, selectedSection: item.sectionID),
      .wrapper(
        .article(
          .p(
            .element(named: "small", nodes: [
              .text("Published on "),
              .element(named: "time", nodes: [
                .text(dateFormatter.string(from: item.date)),
                .attribute(
                  named: "datetime",
                  value: ISO8601DateFormatter().string(from: item.date)
                ),
                .text("."),
              ]),
            ])
          ),
          .div(
            .class("content"),
            .contentBody(item.body)
          ),

          .if(
            !item.tags.isEmpty,
            .p(
              .span("Tagged with: "),
              .tagList(for: item, on: context.site)
            )
          )
        )
      ),
      .footer(for: context.site))
  }

  func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
    .page(for: page, context, body:
      .header(for: context, selectedSection: nil),
      .wrapper(.contentBody(page.body)),
      .footer(for: context.site))
  }

  func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
    .page(for: page, context, body:
      .header(for: context, selectedSection: nil),
      .wrapper(
        .h1("Browse all tags"),
        .ul(
          .class("all-tags"),
          .forEach(page.tags.sorted()) { tag in
            .li(
              .class("tag"),
              .a(
                .href(context.site.path(for: tag)),
                .text(tag.string)
              )
            )
          }
        )
      ),
      .footer(for: context.site))
  }

  func makeTagDetailsHTML(
    for page: TagDetailsPage,
    context: PublishingContext<Site>
  ) throws -> HTML? {
    .page(for: page, context, body:
      .header(for: context, selectedSection: nil),
      .wrapper(
        .h1(
          "Tagged with ",
          .span(.class("tag"), .text(page.tag.string))
        ),
        .a(
          .class("browse-all"),
          .text("Browse all tags"),
          .href(context.site.tagListPath)
        ),
        .itemList(
          for: context.items(
            taggedWith: page.tag,
            sortedBy: \.date,
            order: .descending
          ),
          on: context.site
        )
      ),
      .footer(for: context.site))
  }
}

private extension Node where Context == HTML.BodyContext {
  static func wrapper(_ nodes: Node...) -> Node {
    .div(.class("wrapper"), .group(nodes))
  }

  static func header<T: Website>(
    for context: PublishingContext<T>,
    selectedSection: T.SectionID?
  ) -> Node {
    let sectionIDs = T.SectionID.allCases

    return .header(
      .wrapper(
        .a(.class("site-name"), .href("/"), .text(context.site.name)),
        .if(sectionIDs.count > 1,
            .nav(
              .ul(.forEach(sectionIDs) { section in
                .li(.a(
                  .class(section == selectedSection ? "selected" : ""),
                  .href(context.sections[section].path),
                  .text(context.sections[section].title)
                ))
              })
            ))
      )
    )
  }

  static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
    .ul(
      .class("item-list"),
      .forEach(items) { item in
        .li(.article(
          .h1(.a(
            .href(item.path),
            .text(item.title)
          )),
          .tagList(for: item, on: site),
          .p(.text(item.description))
        ))
      }
    )
  }

  static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
    .ul(.class("tag-list"), .forEach(item.tags) { tag in
      .li(.a(
        .href(site.path(for: tag)),
        .text(tag.string)
      ))
    })
  }

  static func footer<T: Website>(for site: T) -> Node {
    .footer(
      .p(
        .text("Generated using "),
        .a(
          .text("Publish"),
          .href("https://github.com/johnsundell/publish")
        )
      ),
      .p(.a(
        .text("RSS feed"),
        .href("/feed.rss")
      ))
    )
  }
}

private extension HTML {
  static func page<T: Website>(
    for location: Location,
    _ context: PublishingContext<T>,
    body: Node<HTML.BodyContext>...
  ) -> HTML {
    HTML(
      .lang(context.site.language),
      .customHead(for: location, on: context.site, stylesheetPaths: ["/styles.css", "/splash.css"]),
      .element(named: "body", nodes: body)
    )
  }
}

public extension Node where Context == HTML.DocumentContext {
  /// Add an HTML `<head>` tag within the current context, based
  /// on inferred information from the current location and `Website`
  /// implementation.
  /// - parameter location: The location to generate a `<head>` tag for.
  /// - parameter site: The website on which the location is located.
  /// - parameter titleSeparator: Any string to use to separate the location's
  ///   title from the name of the website. Default: `" | "`.
  /// - parameter stylesheetPaths: The paths to any stylesheets to add to
  ///   the resulting HTML page. Default: `styles.css`.
  /// - parameter rssFeedPath: The path to any RSS feed to associate with the
  ///   resulting HTML page. Default: `feed.rss`.
  /// - parameter rssFeedTitle: An optional title for the page's RSS feed.
  static func customHead<T: Website>(
    for location: Location,
    on site: T,
    titleSeparator: String = " | ",
    stylesheetPaths: [Path] = ["/styles.css"],
    rssFeedPath: Path? = .defaultForRSSFeed,
    rssFeedTitle: String? = nil
  ) -> Node {
    var title = location.title

    if title.isEmpty {
      title = site.name
    } else {
      title.append(titleSeparator + site.name)
    }

    var description = location.description

    if description.isEmpty {
      description = site.description
    }

    return .head(
      .encoding(.utf8),
      .siteName(site.name),
      .url(site.url(for: location)),
      .title(title),
      .description(description),
      .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
      .forEach(stylesheetPaths) { .stylesheet($0) },
      .viewport(.accordingToDevice),
      .link(
        .href("https://fonts.googleapis.com/css2?family=Lora:wght@600&display=swap"),
        .rel(.stylesheet)
      ),
      .link(
        .href("https://fonts.googleapis.com/css2?family=Open+Sans&display=swap"),
        .rel(.stylesheet)
      ),
      .unwrap(site.favicon) { .favicon($0) },
      .unwrap(rssFeedPath) { path in
        let title = rssFeedTitle ?? "Subscribe to \(site.name)"
        return .rssFeedLink(path.absoluteString, title: title)
      },
      .unwrap(location.imagePath ?? site.imagePath) { path in
        let url = site.url(for: path)
        return .socialImageLink(url)
      }
    )
  }
}
