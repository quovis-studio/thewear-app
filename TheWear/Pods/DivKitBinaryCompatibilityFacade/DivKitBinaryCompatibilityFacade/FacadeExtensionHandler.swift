import UIKit

internal import DivKit
internal import LayoutKit
internal import VGSL

typealias ViewConfigurator<Subview> = (
  _ view: Subview,
  _ parameters: [String: Any],
  _ properties: DivProperties
) -> Void

final class FacadeExtensionHandler<T: DivKitFacadeWrapperView>: DivExtensionHandler {
  let id: String
  private let applyAfterDecorations: Bool
  private let viewConfigurator: ViewConfigurator<T>

  init(
    id: String,
    applyAfterDecorations: Bool,
    viewConfigurator: @escaping ViewConfigurator<T>
  ) {
    self.id = id
    self.applyAfterDecorations = applyAfterDecorations
    self.viewConfigurator = viewConfigurator
  }

  func applyBeforeBaseProperties(
    to block: Block,
    div: DivBase,
    context: DivBlockModelingContext
  ) -> Block {
    if applyAfterDecorations {
      block
    } else {
      CustomWrapperBlock<T>(
        child: block,
        divProperties: DivProperties(div: div, context: context),
        params: div.extensions?.first(where: { $0.id == id })?.params ?? [:],
        viewConfigurator: viewConfigurator
      )
    }
  }

  func applyAfterBaseProperties(
    to block: Block,
    div: DivBase,
    context: DivBlockModelingContext
  ) -> Block {
    if applyAfterDecorations {
      CustomWrapperBlock<T>(
        child: block,
        divProperties: DivProperties(div: div, context: context),
        params: div.extensions?.first(where: { $0.id == id })?.params ?? [:],
        viewConfigurator: viewConfigurator
      )
    } else {
      block
    }
  }
}

extension WrapperViewConfigurator {
  var extensionHandler: DivExtensionHandler {
    FacadeExtensionHandler<T>(
      id: id,
      applyAfterDecorations: applyAfterDecorations,
      viewConfigurator: { view, parameters, properties in
        self.configure(view: view, parameters: parameters, properties: properties)
      }
    )
  }
}

extension DivProperties {
  convenience init(div: DivBase, context: DivBlockModelingContext) {
    let textProperties: TextProperties? = if let divText = div as? DivText {
      TextProperties(
        fontSize: divText.resolveFontSize(context.expressionResolver),
        lineHeight: divText.resolveLineHeight(context.expressionResolver),
        fontFamily: divText.resolveFontFamily(context.expressionResolver),
        fontWeight: divText.resolveFontWeight(context.expressionResolver)?.cast(),
        textColor: divText.resolveTextColor(context.expressionResolver).systemColor,
        textAlignmentHorizonal: divText.resolveTextAlignmentHorizontal(context.expressionResolver)
          .cast(),
        textAlignmentVertical: divText.resolveTextAlignmentVertical(context.expressionResolver)
          .cast()
      )
    } else {
      nil
    }

    self.init(id: div.id, textProperties: textProperties)
  }
}

extension DivFontWeight {
  fileprivate func cast() -> DivProperties.TextProperties.FontWeight {
    switch self {
    case .light: .light
    case .medium: .medium
    case .regular: .regular
    case .bold: .bold
    }
  }
}

extension DivAlignmentHorizontal {
  fileprivate func cast() -> DivProperties.AlignmentHorizontal {
    switch self {
    case .left: .left
    case .center: .center
    case .right: .right
    case .start: .start
    case .end: .end
    }
  }
}

extension DivAlignmentVertical {
  fileprivate func cast() -> DivProperties.AlignmentVertical {
    switch self {
    case .top: .top
    case .center: .center
    case .bottom: .bottom
    case .baseline: .baseline
    }
  }
}
