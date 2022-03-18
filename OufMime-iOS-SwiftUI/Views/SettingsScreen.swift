//
//  SettingsScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

struct SettingsScreen: View {
  @Binding var hasGameStarted: Bool
  @Binding var isShowingSettings: Bool
  
    var body: some View {
        SizedButton(text: "Jouer !") {
          isShowingSettings = false
          hasGameStarted = true
        }
      .frame(maxHeight: .infinity)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(hasGameStarted: Binding.constant(false), isShowingSettings: Binding.constant(false))
    }
}
