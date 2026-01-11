import Foundation
import UIKit

public class DivProperties {
  public enum AlignmentHorizontal {
    case left
    case center
    case right
    case start
    case end
  }

  public enum AlignmentVertical {
    case top
    case center
    case bottom
    case baseline
  }

  public class TextProperties {
    public enum FontWeight {
      case light
      case medium
      case regular
      case bold
    }

    public let fontSize: Int
    public let lineHeight: Int?
    public let fontFamily: String?
    public let fontWeight: FontWeight?
    public let textColor: UIColor
    public let textAlignmentHorizonal: AlignmentHorizontal
    public let textAlignmentVertical: AlignmentVertical

    init(
      fontSize: Int,
      lineHeight: Int?,
      fontFamily: String?,
      fontWeight: FontWeight?,
      textColor: UIColor,
      textAlignmentHorizonal: AlignmentHorizontal,
      textAlignmentVertical: AlignmentVertical
    ) {
      self.fontSize = fontSize
      self.lineHeight = lineHeight
      self.fontFamily = fontFamily
      self.fontWeight = fontWeight
      self.textColor = textColor
      self.textAlignmentHorizonal = textAlignmentHorizonal
      self.textAlignmentVertical = textAlignmentVertical
    }
  }

  public let id: String?
  public let textProperties: DivProperties.TextProperties?

  init(
    id: String?,
    textProperties: DivProperties.TextProperties?
  ) {
    self.id = id
    self.textProperties = textProperties
  }
}

extension DivProperties: Equatable {
  public static func ==(lhs: DivProperties, rhs: DivProperties) -> Bool {
    lhs.id == rhs.id &&
      lhs.textProperties == rhs.textProperties
  }
}

extension DivProperties.TextProperties: Equatable {
  public static func ==(
    lhs: DivProperties.TextProperties,
    rhs: DivProperties.TextProperties
  ) -> Bool {
    lhs.fontSize == rhs.fontSize &&
      lhs.lineHeight == rhs.lineHeight &&
      lhs.fontFamily == rhs.fontFamily &&
      lhs.textColor == rhs.textColor
  }
}
