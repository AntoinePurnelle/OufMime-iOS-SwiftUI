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
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  var body: some View {
    VStack(spacing: dimens.paddingXLarge) {
      
      if horizontalSizeClass == .regular {
        HStack {
          TeamScoreboardView(team: 0)
            .frame(maxWidth: .infinity)
          TeamScoreboardView(team: 1)
            .frame(maxWidth: .infinity)
        }
        .padding()
      } else {
        TeamScoreboardView(team: 0)
        TeamScoreboardView(team: 1)
      }
      
      let buttonText  = vm.hasMoreRounds ? "next_round" : "new_game"
      
      SizedButton(
        text: buttonText,
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
      TitleTextView(text: team == 0 ? "team_blue" : "team_orange", color: .accentColor)
      
      ScoreLineView(scoreName: "describe", score: vm.getScore(inRound: 0, forTeam: team), color: .accentColor)
      
      ScoreLineView(scoreName: "word", score: vm.getScore(inRound: 1, forTeam: team), color: .accentColor)
      
      ScoreLineView(scoreName: "mime", score: vm.getScore(inRound: 2, forTeam: team), color: .accentColor)
      
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
      .previewDevice("iPhone 13")
      .environment(\.locale, .init(identifier: "fr"))
    
    ScoreboardScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(AppState())
      .environmentObject(Dimens(isLarge: true))
      .previewInterfaceOrientation(.landscapeLeft)
      .previewDevice("iPad Pro (12.9-inch) (5th generation)")
      .environment(\.locale, .init(identifier: "en"))
    
    TeamScoreboardView(team: 0)
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
      .previewLayout(.fixed(width: 400, height: 600))
  }
}
