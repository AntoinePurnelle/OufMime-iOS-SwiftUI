//
//  SettingsScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

struct SettingsScreen: View {
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    SizedButton(text: "Jouer !", textSize: .big) {
      appState.welcomeScreenId = UUID()
    }
    .frame(maxHeight: .infinity)
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen()
      .environmentObject(Dimens())
      .environmentObject(AppState())
  }
}
