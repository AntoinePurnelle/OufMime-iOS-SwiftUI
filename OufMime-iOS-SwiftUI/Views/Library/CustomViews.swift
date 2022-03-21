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
  var textSize: ButtonTextSize = .medium
  var onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Text(text.uppercased())
        .foregroundColor(.white)
        .font(.custom(Constants.font, size: dimens.getButtonDimens(for: textSize)))
        .fontWeight(.medium)
        .padding()
        .background(Color.accentColor)
        .cornerRadius(8.0)
    }
  }
}

struct BodyTextView: View {
  @EnvironmentObject var dimens: Dimens
  
  var text: String
  var color: Color = .black
  
  var body: some View {
    Text(text)
      .font(.custom(Constants.font, size: dimens.bodyText))
      .foregroundColor(color)
  }
}

struct AppIcon: View {
  @EnvironmentObject var dimens: Dimens
  
  var inverted: Bool = false
  
  var body: some View {
    Image(inverted ? "ic_launcher_inverted" : "ic_launcher")
      .resizable()
      .scaledToFit()
  }
  
}

struct CustomViews_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      SizedButton(text: "Button",onClick: {})
        .environmentObject(WordsViewModel())
        .environmentObject(Dimens())
      BodyTextView(text: "Body Text View", color: .primaryColor)
    }
    .environmentObject(Dimens())
  }
}
