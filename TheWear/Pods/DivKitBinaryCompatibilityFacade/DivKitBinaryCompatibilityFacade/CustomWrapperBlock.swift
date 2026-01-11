import UIKit

internal import LayoutKit
internal import VGSL

final class CustomWrapperBlock<Subview: DivKitFacadeWrapperView>: WrapperBlock,
  LayoutCachingDefaultImpl {
  var child: LayoutKit.Block

  private let divProperties: DivProperties
  private let params: [String: Any]
  private let viewConfigurator: ViewConfigurator<Subview>

  init(
    child: LayoutKit.Block,
    divProperties: DivProperties,
    params: [String: Any],
    viewConfigurator: @escaping ViewConfigurator<Subview>
  ) {
    self.child = child
    self.divProperties = divProperties
    self.params = params
    self.viewConfigurator = viewConfigurator
  }

  func makeCopy(wrapping block: LayoutKit.Block) -> CustomWrapperBlock {
    CustomWrapperBlock(
      child: block,
      divProperties: divProperties,
      params: params,
      viewConfigurator: viewConfigurator
    )
  }

  var debugDescription: String {
    "CustomWrapperBlock for view with params \(params)"
  }

  func equals(_ other: Block) -> Bool {
    if self === other {
      return true
    }

    guard let other = other as? Self else {
      return false
    }

    return self.child == other.child &&
      self.divProperties == other.divProperties &&
      NSDictionary(dictionary: self.params) == NSDictionary(dictionary: other.params)
  }
}

extension CustomWrapperBlock {
  static func makeBlockView() -> LayoutKit.BlockView {
    let wrapperBlockView = CustomWrapperBlockView()
    wrapperBlockView.contentView = Subview()
    return wrapperBlockView
  }

  func canConfigureBlockView(_ view: LayoutKit.BlockView) -> Bool {
    (view as? CustomWrapperBlockView)?.contentView is Subview
  }

  func configureBlockView(
    _ view: LayoutKit.BlockView,
    observer: LayoutKit.ElementStateObserver?,
    overscrollDelegate: VGSL.ScrollDelegate?,
    renderingDelegate: LayoutKit.RenderingDelegate?
  ) {
    guard let wrapperBlockView = view as? CustomWrapperBlockView,
          let wrappedView = wrapperBlockView.contentView as? Subview else { return }

    let newChildView = child.reuse(
      wrapperBlockView.lastChildView,
      observer: observer,
      overscrollDelegate: overscrollDelegate,
      renderingDelegate: renderingDelegate,
      superview: nil
    )
    wrapperBlockView.lastChildView = newChildView
    wrappedView.injectChildView(newChildView)
    viewConfigurator(wrappedView, params, divProperties)
    if let blockViewId = divProperties.id {
      renderingDelegate?.mapView(wrapperBlockView, to: BlockViewID(rawValue: blockViewId))
    }
  }
}
