//
//  TurnStartScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI

struct TurnStartScreen: View {
  @State var isPlaying = false
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  @EnvironmentObject var appState: AppState
  
  var invertColors: Bool
  
  var body: some View {
    let background = invertColors ? Color.accentColor : Color.primaryColor
    
    ZStack {
      background
        .edgesIgnoringSafeArea(.all)
      
      VStack(alignment: .center, spacing: .leastNormalMagnitude) {
        HeaderView(
          team1TotalScore: vm.getTotalScore(forTeam: 0),
          team1RoundScore: vm.getCurrentRoundScore(forTeam: 0),
          team2TotalScore: vm.getTotalScore(forTeam: 1),
          team2RoundScore: vm.getCurrentRoundScore(forTeam: 1),
          invertColors: invertColors
        )
        .frame(maxHeight: .infinity)
        
        Text("Manche \(vm.currentRound + 1) :\n\(roundName)")
          .foregroundColor(.white)
          .font(.custom(Constants.font, size: dimens.titleText))
          .multilineTextAlignment(.center)
          .frame(maxHeight: .infinity)
        
        NavigationLink(
          destination: PlayScreen()
          .navigationBarHidden(true),
          isActive: $isPlaying
        ) {
          SizedButton(
            text: "\(vm.currentTeamName), jouez !".uppercased(),
            onClick: {
              isPlaying = true
            }
          )
          .frame(maxHeight: .infinity)
        }
        .isDetailLink(false)
      }.padding()
      
    }
  }
  
  var roundName: String {
    get {
      switch(vm.currentRound) {
      case 0: return "Décrire"
      case 1: return "Un mot"
      default: return "Mimer"
      }
    }
  }
}

struct TurnStartScreen_Previews: PreviewProvider {
  static var previews: some View {
    TurnStartScreen(
      invertColors: false
    )
    .environmentObject(WordsViewModel())
    .environmentObject(Dimens())
    .environmentObject(AppState())
  }
}
