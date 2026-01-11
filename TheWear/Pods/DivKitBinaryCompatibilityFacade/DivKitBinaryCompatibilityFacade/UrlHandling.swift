import Foundation

internal import DivKit

public protocol UrlHandling {
  func handle(url: URL, payload: [String: Any]?)
}

final class UrlHandlerAdapter: DivUrlHandler {
  private let handler: UrlHandling

  init(handler: UrlHandling) {
    self.handler = handler
  }

  func handle(_ url: URL, info: DivActionInfo, sender _: AnyObject?) {
    handler.handle(url: url, payload: info.payload)
  }
}
