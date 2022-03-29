//
//  WelcomeScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

struct WelcomeScreen: View {
  @State var hasGameStarted = false
  @State var isShowingSettings = false
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    VStack(alignment: .center, spacing: .leastNormalMagnitude) {
      Text("app_name")
        .foregroundColor(.primaryColor)
        .font(.custom(Constants.font, size: dimens.bigTitleText))
        .fontWeight(.bold)
        .frame(maxHeight: .infinity)
      
      NavigationLink(
        destination: TurnStartScreen()
          .navigationBarHidden(true)
          .id(appState.turnStartScreenId),
        isActive: $hasGameStarted
      ) {
        SizedButton(text: "start", textSize: .big) {
          vm.initGame {
            vm.initRound()
            hasGameStarted = true
          }
        }
      }
      .isDetailLink(false)
      .frame(maxHeight: .infinity)
      
      NavigationLink(
        destination: SettingsScreen().navigationBarHidden(true),
        isActive: $isShowingSettings
      ) {
        Button(action: { isShowingSettings = true }) {
          Text("settings")
            .font(.custom(Constants.font, size: dimens.bodyText))
            .foregroundColor(.gray)
        }
      }
      .isDetailLink(false)
      .frame(maxHeight: .infinity)
    }
  }
}

struct WelcomeScreen_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WelcomeScreen()
        .environmentObject(WordsViewModel())
        .environmentObject(Dimens())
        .environmentObject(AppState())
        .previewDevice("iPhone 13")
        .environment(\.locale, .init(identifier: "en"))
      
      WelcomeScreen()
        .environmentObject(WordsViewModel())
        .environmentObject(Dimens(isLarge: true))
        .environmentObject(AppState())
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPad Pro (9.7-inch)")
        .environment(\.locale, .init(identifier: "fr"))
    }
  }
}
