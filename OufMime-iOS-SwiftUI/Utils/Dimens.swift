//
//  Dimens.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

class Dimens: ObservableObject {
  var bodyText = CGFloat(16.0)
  var titleText = CGFloat(42.0)
  var bigTitleText = CGFloat(64.0)
  var subtitleText = CGFloat(20.0)

  var smallButtonText = CGFloat(16.0)
  var mediumButtonText = CGFloat(24.0)
  var bigButtonText = CGFloat(32.0)
  
  var paddingXSmall = CGFloat(2.0)
  var paddingSmall = CGFloat(4.0)
  var paddingMedium = CGFloat(8.0)
  var paddingLarge = CGFloat(16.0)
  var paddingXLarge = CGFloat(32.0)
  
  var borderSmall = CGFloat(1.0)
  var borderMedium = CGFloat(2.0)
  
  var iconSmall = CGFloat(50.0)
  var iconMedium = CGFloat(100.0)
  
  var timerSize = CGFloat(100.0)
  var timerPathStrokeWidth = CGFloat(2.0)
  var timerStrokeWidth = CGFloat(6.0)
  
  var cornerRadiusMedium = CGFloat(8.0)
  var cornerRadiusLarge = CGFloat(20.0)

  func getButtonDimens(for size: ButtonTextSize) -> CGFloat {
    switch(size) {
    case .small:
      return smallButtonText
    case .medium:
      return mediumButtonText
    default:
      return bigButtonText
    }
  }
}

enum ButtonTextSize: CGFloat {
  case small
  case medium
  case big
}
