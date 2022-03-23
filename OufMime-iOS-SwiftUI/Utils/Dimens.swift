//
//  Dimens.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

class Dimens: ObservableObject {
  var bodyText: CGFloat
  var titleText: CGFloat
  var bigTitleText: CGFloat
  var subtitleText: CGFloat
  
  var smallButtonText: CGFloat
  var mediumButtonText: CGFloat
  var bigButtonText: CGFloat
  
  var simpleScoreboardWidth: CGFloat
  var fullScoreboardWifth: CGFloat
  
  var paddingXSmall: CGFloat
  var paddingSmall: CGFloat
  var paddingMedium: CGFloat
  var paddingLarge: CGFloat
  var paddingXLarge: CGFloat
  
  var borderSmall: CGFloat
  var borderMedium: CGFloat
  
  var iconSmall: CGFloat
  var iconMedium: CGFloat
  var iconLarge: CGFloat
  
  var timerSize: CGFloat
  var timerPathStrokeWidth: CGFloat
  var timerStrokeWidth: CGFloat
  
  var cornerRadiusMedium: CGFloat
  var cornerRadiusLarge: CGFloat
  
  init(isLarge: Bool = false) {
    if isLarge {
      bodyText = CGFloat(24.0)
      titleText = CGFloat(56.0)
      bigTitleText = CGFloat(96.0)
      subtitleText = CGFloat(32.0)
      
      smallButtonText = CGFloat(24.0)
      mediumButtonText = CGFloat(32.0)
      bigButtonText = CGFloat(40.0)
      
      simpleScoreboardWidth = CGFloat(200.0)
      fullScoreboardWifth = CGFloat(400.0)
      
      paddingXSmall = CGFloat(4.0)
      paddingSmall = CGFloat(8.0)
      paddingMedium = CGFloat(16.0)
      paddingLarge = CGFloat(32.0)
      paddingXLarge = CGFloat(64.0)
      
      borderSmall = CGFloat(2.0)
      borderMedium = CGFloat(4.0)
      
      iconSmall = CGFloat(32.0)
      iconMedium = CGFloat(140.0)
      iconLarge = CGFloat(200.0)
      
      timerSize = CGFloat(160.0)
      timerPathStrokeWidth = CGFloat(4.0)
      timerStrokeWidth = CGFloat(12.0)
      
      cornerRadiusMedium = CGFloat(12.0)
      cornerRadiusLarge = CGFloat(32.0)
    } else {
      bodyText = CGFloat(16.0)
      titleText = CGFloat(42.0)
      bigTitleText = CGFloat(64.0)
      subtitleText = CGFloat(20.0)
      
      smallButtonText = CGFloat(16.0)
      mediumButtonText = CGFloat(24.0)
      bigButtonText = CGFloat(32.0)
      
      simpleScoreboardWidth = CGFloat(120.0)
      fullScoreboardWifth = CGFloat(200.0)
      
      paddingXSmall = CGFloat(2.0)
      paddingSmall = CGFloat(4.0)
      paddingMedium = CGFloat(8.0)
      paddingLarge = CGFloat(16.0)
      paddingXLarge = CGFloat(32.0)
      
      borderSmall = CGFloat(1.0)
      borderMedium = CGFloat(2.0)
      
      iconSmall = CGFloat(24.0)
      iconMedium = CGFloat(70.0)
      iconLarge = CGFloat(100.0)
      
      timerSize = CGFloat(100.0)
      timerPathStrokeWidth = CGFloat(2.0)
      timerStrokeWidth = CGFloat(6.0)
      
      cornerRadiusMedium = CGFloat(8.0)
      cornerRadiusLarge = CGFloat(20.0)
    }
  }
  
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
