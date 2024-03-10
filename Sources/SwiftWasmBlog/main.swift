import CNAMEPublishPlugin
import Foundation
import Plot
import Publish
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct Blog: Website {
  enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case posts
  }

  struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
  }

  // Update these properties to configure your website:
  var url = URL(string: "https://blog.swiftwasm.org")!
  var name = "SwiftWasm Blog"
  var description = ""
  var language: Language { .english }
  var imagePath: Path? { "images/logo.png" }
}

// This will generate your website using the built-in Foundation theme:
try Blog().publish(using: [
  .installPlugin(.splash(withClassPrefix: "splash-")),
  .installPlugin(.generateCNAME(with: "blog.swiftwasm.org")),
  .copyResources(at: "Images", to: "images"),
  .addMarkdownFiles(),
  .generateHTML(withTheme: .swiftwasm),
  .generateRSSFeed(including: [.posts]),
  .generateSiteMap(),
])
