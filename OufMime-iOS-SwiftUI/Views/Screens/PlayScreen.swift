//
//  PlayScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 21/03/2022.
//

import SwiftUI

struct PlayScreen: View {
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    VStack {
      Button(action: {
        appState.welcomeScreenId = UUID()
      }) {
        Text("Finish Game")
      }
      Button(action: {
        appState.turnStartScreenId = UUID()
      }) {
        Text("Finish Turn")
      }
    }
  }
}

struct PlayScreen_Previews: PreviewProvider {
  static var previews: some View {
    PlayScreen()
    .environmentObject(Dimens())
    .environmentObject(AppState())
  }
}
