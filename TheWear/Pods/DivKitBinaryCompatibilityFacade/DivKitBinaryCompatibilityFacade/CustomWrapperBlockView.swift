import UIKit

internal import LayoutKit
internal import VGSL

final class CustomWrapperBlockView: BlockView {
  var lastChildView: BlockView?
  var effectiveBackgroundColor: UIColor?

  var contentView: UIView? {
    didSet {
      oldValue?.removeFromSuperview()
      if let contentView {
        self.addSubview(contentView)
        contentView.frame = bounds
      }
    }
  }

  init() {
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView?.frame = bounds
  }

  func onVisibleBoundsChanged(from _: CGRect, to _: CGRect) {}
}
