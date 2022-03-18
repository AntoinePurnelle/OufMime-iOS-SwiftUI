//
//  CustomViews.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

struct SizedButton: View {
  @EnvironmentObject var dimens: Dimens
  var text: String
  var textSize: ButtonTextSize = .big
  var onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Text(text.uppercased())
        .foregroundColor(.white)
        .font(.custom(Constants.font, size: dimens.getButtonDimens(for: textSize)))
        .fontWeight(.medium)
        .padding()
        .background(Color.accent)
        .cornerRadius(8.0)
    }
  }
}

struct CustomViews_Previews: PreviewProvider {
  static var previews: some View {
    SizedButton(text: "Button",onClick: {})
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
  }
}
