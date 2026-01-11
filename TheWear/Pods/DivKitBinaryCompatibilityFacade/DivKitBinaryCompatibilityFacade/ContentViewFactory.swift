import UIKit

public protocol ContentViewFactory {
  func makeView(id: String, data: [String: Any]) -> UIView
}
