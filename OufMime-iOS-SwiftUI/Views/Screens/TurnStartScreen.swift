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
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  var body: some View {
    let background = vm.shouldInvertColors ? Color.accentColor : Color.primaryColor
    
    ZStack {
      background
        .edgesIgnoringSafeArea(.all)
      
      VStack(alignment: .center, spacing: .leastNormalMagnitude) {
        HeaderView(
          team1TotalScore: vm.getTotalScore(forTeam: 0),
          team1RoundScore: vm.getCurrentRoundScore(forTeam: 0),
          team2TotalScore: vm.getTotalScore(forTeam: 1),
          team2RoundScore: vm.getCurrentRoundScore(forTeam: 1),
          invertColors: vm.shouldInvertColors
        )
        .frame(maxHeight: .infinity)
        
        if horizontalSizeClass == .regular {
          Spacer()
            .frame(maxHeight: 80)
        }
        
        let separator = horizontalSizeClass == .regular ? " " : "\n"
        
        TitleTextView(
          text: "Manche \(vm.currentRound + 1) :\(separator + roundName)",
          color: .white
        )
        .frame(maxHeight: .infinity)
        
        NavigationLink(
          destination: PlayScreen()
            .navigationBarHidden(true),
          isActive: $isPlaying
        ) {
          SizedButton(
            text: "\(vm.currentTeamName), jouez !".uppercased(),
            invertColor: vm.shouldInvertColors,
            onClick: {
              vm.initTurn()
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
    Group {
      TurnStartScreen()
        .environmentObject(WordsViewModel())
        .environmentObject(Dimens())
        .previewDevice("iPhone 13")
      
      TurnStartScreen()
        .environmentObject(WordsViewModel())
        .environmentObject(Dimens(isLarge: true))
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
  }
}
