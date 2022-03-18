//
//  WelcomeScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

struct WelcomeScreen: View {
  @Binding var hasGameStarted: Bool
  @Binding var isShowingSettings: Bool
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens

  var body: some View {
    VStack(alignment: .center, spacing: .leastNormalMagnitude) {
      Text("OufMime!")
        .foregroundColor(.primaryColor)
        .font(.custom(Constants.font, size: dimens.bigTitleText))
        .fontWeight(.bold)
        .frame(maxHeight: .infinity)

      NavigationLink(
        destination: TurnStartScreen().navigationBarHidden(true),
        isActive: $hasGameStarted
      ) {
        SizedButton(text: "Jouer !") {
          hasGameStarted = true
        }
      }
        .frame(maxHeight: .infinity)

      NavigationLink(destination: SettingsScreen(hasGameStarted: $hasGameStarted, isShowingSettings: $isShowingSettings).navigationBarHidden(true), isActive: $isShowingSettings) {
        Button(action: { isShowingSettings = true }) {
          Text("Paramètres")
            .font(.custom(Constants.font, size: dimens.bodyText))
            .foregroundColor(.gray)
        }
      }
        .frame(maxHeight: .infinity)
    }
  }
}

struct WelcomeScreen_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeScreen(hasGameStarted: Binding.constant(false), isShowingSettings: Binding.constant(false))
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
  }
}
