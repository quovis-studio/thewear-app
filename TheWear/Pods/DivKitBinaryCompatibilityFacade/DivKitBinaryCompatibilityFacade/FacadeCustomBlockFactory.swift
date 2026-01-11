import UIKit

internal import DivKit
internal import LayoutKit

final class FacadeCustomBlockFactory: DivCustomBlockFactory {
  private let viewFactory: ContentViewFactory
  private let viewsCache = ViewCache()

  init(
    viewFactory: ContentViewFactory
  ) {
    self.viewFactory = viewFactory
  }

  func makeBlock(data: DivCustomData, context _: DivBlockModelingContext) -> Block {
    let view = getContentView(data.name, data.data)
    let sizeCalculator = ClosureIntrinsicCalculator(
      widthGetter: { view.intrinsicContentSize.width },
      heightGetter: { width in view.sizeThatFits(CGSize(width: width, height: .infinity)).height }
    )

    let widthTrait: GenericViewBlock.Trait = switch data.widthTrait {
      case let .fixed(value):
        .fixed(value)
      case .intrinsic:
        .intrinsic(sizeCalculator)
      case .weighted:
        .resizable
    }

    let heightTrait: GenericViewBlock.Trait = switch data.heightTrait {
      case let .fixed(value):
        .fixed(value)
      case .intrinsic:
        .intrinsic(sizeCalculator)
      case .weighted:
        .resizable
    }

    return GenericViewBlock(
      content: .view(view),
      width: widthTrait,
      height: heightTrait
    )
  }

  private func getContentView(_ name: String, _ data: [String: Any]) -> UIView {
    if let view = viewsCache[name, data] {
      return view
    }

    let view = viewFactory.makeView(id: name, data: data)
    viewsCache[name, data] = view
    return view
  }
}

private final class ViewCache {
  private var store: [Key: UIView] = [:]

  private struct Key: Hashable {
    let name: String
    let json: NSDictionary

    init(name: String, jsonObject: [String: Any]) {
      self.name = name
      self.json = NSDictionary(dictionary: jsonObject)
    }
  }

  subscript(name: String, data: [String: Any]) -> UIView? {
    get {
      let key = Key(name: name, jsonObject: data)
      return store[key]
    }
    set {
      let key = Key(name: name, jsonObject: data)
      store[key] = newValue
    }
  }
}
