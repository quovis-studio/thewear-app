import UIKit

internal import DivKit
internal import VGSL

public enum FontWeight: String, CaseIterable {
  case light
  case medium
  case regular
  case bold
}

public protocol FontProviding {
  func font(family: String, weight: FontWeight, size: CGFloat) -> UIFont
}

final class FontProviderAdapter: DivFontProvider {
  private let fontProvider: FontProviding

  init(fontProvider: FontProviding) {
    self.fontProvider = fontProvider
  }

  func font(family: String, weight: DivFontWeight, size: CGFloat) -> VGSLUI.Font {
    fontProvider.font(family: family, weight: weight.cast(), size: size)
  }
}

extension DivFontWeight {
  fileprivate func cast() -> FontWeight {
    switch self {
    case .light:
      return .light
    case .medium:
      return .medium
    case .regular:
      return .regular
    case .bold:
      return .bold
    }
  }
}
