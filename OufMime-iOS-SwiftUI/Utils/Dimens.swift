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
