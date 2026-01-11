import UIKit

public protocol DivKitFacadeWrapperView: UIView {
  func injectChildView(_ view: UIView)
}

public protocol WrapperViewConfigurator {
  associatedtype T: DivKitFacadeWrapperView
  var id: String { get }
  var applyAfterDecorations: Bool { get }
  func configure(view: T, parameters: [String: Any], properties: DivProperties)
}
