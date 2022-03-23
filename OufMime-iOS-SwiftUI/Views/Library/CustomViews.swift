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
  var invertColor = false
  var onClick: () -> Void
  
  var body: some View {
    Button(action: onClick) {
      Text(text.uppercased())
        .foregroundColor(.white)
        .font(.custom(Constants.font, size: dimens.getButtonDimens(for: textSize)))
        .fontWeight(.medium)
        .padding()
        .background(invertColor ? Color.primaryColor : Color.accentColor)
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

struct TitleTextView: View {
  @EnvironmentObject var dimens: Dimens
  
  var text: String
  var color: Color = .black
  
  var body: some View {
    Text(text)
      .font(.custom(Constants.font, size: dimens.titleText))
      .multilineTextAlignment(.center)
      .foregroundColor(color)
  }
}

struct BigTitleTextView: View {
  @EnvironmentObject var dimens: Dimens
  
  var text: String
  var color: Color = .black
  
  var body: some View {
    Text(text)
      .font(.custom(Constants.font, size: dimens.bigTitleText))
      .multilineTextAlignment(.center)
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

struct RoundIconButton: View {
  @EnvironmentObject var dimens: Dimens
  
  var systemName: String
  var backgroungColor: Color
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      RoundIcon(
        systemName: systemName,
        backgroungColor: backgroungColor,
        size: dimens.iconLarge
      )
    }
  }
}

struct RoundIcon:View {
  var systemName: String
  var backgroungColor: Color
  var size: CGFloat
  
  var body: some View {
    ZStack {
      Circle()
        .fill(backgroungColor)
        .frame(
          width: size,
          height: size)
      
      Image(systemName: systemName)
        .resizable()
        .frame(
          width: size / 2,
          height: size / 2
        )
        .font(.title)
        .foregroundColor(.white)
    }
  }
}

struct CustomViews_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      SizedButton(text: "Button", onClick: { })
        .environmentObject(WordsViewModel())
        .environmentObject(Dimens())
      BodyTextView(text: "Body Text View", color: .primaryColor)
        .environmentObject(Dimens())
      AppIcon()
        .environmentObject(Dimens())
        .frame(width: 100, height: 100)
      RoundIconButton(
        systemName: "checkmark",
        backgroungColor: .greenColor
      ) {}
        .environmentObject(Dimens())
      RoundIconButton(
        systemName: "xmark",
        backgroungColor: .redColor
      ) {}
        .environmentObject(Dimens())
    }
    .environmentObject(Dimens())
  }
}
