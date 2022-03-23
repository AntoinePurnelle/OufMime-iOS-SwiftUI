//
//  ScoreboardScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 22/03/2022.
//

import SwiftUI

struct ScoreboardScreen: View {
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var dimens: Dimens
  
  var body: some View {
    VStack(spacing: dimens.paddingXLarge) {
      
      TeamScoreboardView(team: 0)
      
      TeamScoreboardView(team: 1)
      
      let buttonText  = vm.hasMoreRounds ? "Manche suivante !" : "Nouvelle partie !"
      
      SizedButton(
        text: buttonText.uppercased(),
        onClick: {
          if vm.hasMoreRounds {
            vm.finishRound()
            appState.popToTurnStart()
          } else {
            appState.popToWelcome()
          }
        }
      )
    }
  }
}

struct TeamScoreboardView: View {
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  
  var team: Int
  
  var body: some View {
    VStack(spacing: dimens.paddingMedium) {
      TitleTextView(text: team == 0 ? "Les Bleus" : "Les Oranges", color: .accentColor)
      
      ScoreLineView(scoreName: "Décrire", score: vm.getScore(inRound: 0, forTeam: team), color: .accentColor)
      
      ScoreLineView(scoreName: "Un mot", score: vm.getScore(inRound: 1, forTeam: team), color: .accentColor)
      
      ScoreLineView(scoreName: "Mimer", score: vm.getScore(inRound: 2, forTeam: team), color: .accentColor)
      
      TitleTextView(text: String(vm.getTotalScore(forTeam: team)), color: .accentColor)
    }
    .padding(dimens.paddingLarge)
    .background(
      RoundedRectangle(cornerRadius: dimens.cornerRadiusMedium)
        .strokeBorder(vm.getColor(forteam: team), lineWidth: dimens.timerStrokeWidth)
    )
    .frame(width: dimens.fullScoreboardWifth)
  }
}


struct ScoreboardScreen_Previews: PreviewProvider {
  static var previews: some View {
    ScoreboardScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
      .environmentObject(AppState())
    
    TeamScoreboardView(team: 0)
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
      .previewLayout(.fixed(width: 400, height: 600))
  }
}
