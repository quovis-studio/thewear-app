import UIKit

@_spi(Legacy)
internal import DivKit
internal import VGSL

public protocol FacadeView: UIView {
  func setVariables(_ variables: [String: Any])
}

public enum DivKitFacade {
  public static func createView(
    json: [String: Any],
    localImageProvider: LocalImageProviding? = nil,
    fontProvider: FontProviding? = nil,
    customViewFactory: ContentViewFactory? = nil,
    wrapperConfigurators: [any WrapperViewConfigurator] = [],
    urlHandler: UrlHandling,
    urlSessionConfiguration: URLSessionConfiguration? = nil
  ) async -> FacadeView? {
    let requestPerformer = createRequestPerformer(urlSessionConfiguration: urlSessionConfiguration)
    let imageHolderFactory = createImageHolderFactory(
      localImageProvider: localImageProvider,
      requestPerformer: requestPerformer
    )

    let divKitComponents = DivKitComponents(
      divCustomBlockFactory: customViewFactory.map(FacadeCustomBlockFactory.init),
      extensionHandlers: wrapperConfigurators.map(\.extensionHandler),
      fontProvider: fontProvider.map(FontProviderAdapter.init),
      imageHolderFactory: imageHolderFactory,
      requestPerformer: requestPerformer,
      reporter: VisibilityAwareReporter(urlHandler: urlHandler),
      urlHandler: UrlHandlerAdapter(handler: urlHandler)
    )

    let divView = await DivView(divKitComponents: divKitComponents)

    guard let card = json["card"] as? [String: Any],
          let divCardId = card["log_id"] as? String else {
      return nil
    }

    await divView.setSource(
      DivViewSource(
        kind: .json(json),
        cardId: DivCardID(rawValue: divCardId)
      )
    )

    let task = Task { @MainActor in
      let root = VisibilityTrackingRoot(
        divCardId: DivCardID(rawValue: divCardId),
        divKitComponents: divKitComponents
      )
      root.content = divView
      root.layoutIfNeeded()
      return root
    }

    return await task.value
  }
  
  public static func createViewSync(
    json: [String: Any],
    localImageProvider: LocalImageProviding? = nil,
    fontProvider: FontProviding? = nil,
    customViewFactory: ContentViewFactory? = nil,
    wrapperConfigurators: [any WrapperViewConfigurator] = [],
    urlHandler: UrlHandling,
    urlSessionConfiguration: URLSessionConfiguration? = nil
  ) -> FacadeView? {
    let requestPerformer = createRequestPerformer(urlSessionConfiguration: urlSessionConfiguration)
    let imageHolderFactory = createImageHolderFactory(
      localImageProvider: localImageProvider,
      requestPerformer: requestPerformer
    )

    let divKitComponents = DivKitComponents(
      divCustomBlockFactory: customViewFactory.map(FacadeCustomBlockFactory.init),
      extensionHandlers: wrapperConfigurators.map(\.extensionHandler),
      fontProvider: fontProvider.map(FontProviderAdapter.init),
      imageHolderFactory: imageHolderFactory,
      requestPerformer: requestPerformer,
      reporter: VisibilityAwareReporter(urlHandler: urlHandler),
      urlHandler: UrlHandlerAdapter(handler: urlHandler)
    )

    let divView = DivView(divKitComponents: divKitComponents)

    guard let card = json["card"] as? [String: Any],
          let divCardId = card["log_id"] as? String else {
      return nil
    }

    divView.setSource(
      DivViewSource(
        kind: .json(json),
        cardId: DivCardID(rawValue: divCardId)
      )
    )

    let root = VisibilityTrackingRoot(
      divCardId: DivCardID(rawValue: divCardId),
      divKitComponents: divKitComponents
    )
    root.content = divView
    root.layoutIfNeeded()
    
    return root
  }
}

private final class VisibilityTrackingRoot: UIView {
  private let divKitComponents: DivKitComponents
  private let divCardId: DivCardID

  init(divCardId: DivCardID, divKitComponents: DivKitComponents) {
    self.divCardId = divCardId
    self.divKitComponents = divKitComponents
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public var content: (VisibleBoundsTracking & UIView)? {
    didSet {
      if window != nil, let oldValue {
        oldValue.onVisibleBoundsChanged(from: oldValue.bounds, to: .zero)
      }
      oldValue?.removeFromSuperview()
      addSubviews(content.asArray())
      setNeedsLayout()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    guard let content else { return }
    let oldBounds = content.bounds
    content.frame = bounds
    content.onVisibleBoundsChanged(from: oldBounds, to: content.bounds)
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    guard let content else { return }

    if window == nil {
      content.onVisibleBoundsChanged(from: content.bounds, to: .zero)
    } else {
      content.onVisibleBoundsChanged(from: .zero, to: content.bounds)
    }
  }
}

extension VisibilityTrackingRoot: FacadeView {
  public func setVariables(_ variables: [String: Any]) {
    divKitComponents.variablesStorage.append(
      variables: variables.divVariables,
      for: divCardId
    )
  }
}

extension [String: Any] {
  fileprivate var divVariables: [DivVariableName: DivVariableValue] {
    compactMapValues {
      switch $0 {
      case let value as String:
        DivVariableValue.string(value)
      case let value as Double:
        DivVariableValue.number(value)
      case let value as Int:
        DivVariableValue.integer(value)
      case let value as Bool:
        DivVariableValue.bool(value)
      case let value as Color:
        DivVariableValue.color(value)
      case let value as URL:
        DivVariableValue.url(value)
      case let value as DivDictionary:
        DivVariableValue.dict(value)
      case let value as DivArray:
        DivVariableValue.array(value)
      default:
        nil
      }
    }.map(key: { DivVariableName(rawValue: $0) }, value: { $0 })
  }
}

private func createRequestPerformer(urlSessionConfiguration: URLSessionConfiguration?) -> URLRequestPerforming {
  let sessionDelegate = URLSessionDelegateImpl()
  let session = URLSession(
    configuration: urlSessionConfiguration ?? .default,
    delegate: sessionDelegate,
    delegateQueue: .main
  )

  return URLRequestPerformer(
    urlSession: session,
    URLSessionDelegate: sessionDelegate,
    urlTransform: nil
  )
}

private func createImageHolderFactory(
  localImageProvider: LocalImageProviding?,
  requestPerformer: URLRequestPerforming
) -> DivImageHolderFactory? {
  guard let localImageProvider else { return nil }

  return LocalImageHolderFactory(
    localImageProvider: localImageProvider,
    imageHolderFactory: DefaultImageHolderFactory(
      requestPerformer: requestPerformer
    )
  )
}
