internal import DivKit
internal import VGSL

final class VisibilityAwareReporter: DivReporter {
  private let urlHandler: UrlHandling

  init(urlHandler: UrlHandling) {
    self.urlHandler = urlHandler
  }

  func reportError(cardId _: DivCardID, error _: DivError) {}

  func reportAction(cardId _: DivCardID, info: DivActionInfo) {
    switch info.source {
    case .visibility, .disappear:
      if let url = info.url, url.scheme != "div-action" {
        urlHandler.handle(url: url, payload: info.payload)
      }
    default:
      break
    }
  }
}
