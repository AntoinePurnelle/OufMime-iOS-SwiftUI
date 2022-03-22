//
//  TurnEndScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 21/03/2022.
//

import SwiftUI

struct TurnEndScreen: View {
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  @EnvironmentObject var appState: AppState
  @State var showScoreboard = false
  
  var body: some View {
    let background = vm.shouldInvertColors ? Color.accentColor : Color.primaryColor
    
    UITableView.appearance().backgroundColor = .clear
    
    return ZStack {
      background
        .edgesIgnoringSafeArea(.all)
      
      VStack(spacing: dimens.paddingLarge) {
        AppIcon(inverted: vm.shouldInvertColors)
          .frame(width: dimens.iconMedium, height: dimens.iconMedium)
        
        ScoreboardView(
          topLabel: "Trouvés",
          topScore: vm.wordsFoundInTurnCount,
          bottomLabel: "Manqués",
          bottomScore: vm.wordsMissedInTurnCount,
          color: .white
        )
        
        List(0..<vm.wordsPlayedInTurn.count, id: \.self) { index in
          let wordPlayed = vm.wordsPlayedInTurn[index]
          
          Button(action: {
            vm.changeValueInPlayedWords(atRow: index)
          }) {
            WordPlayedView(word: wordPlayed.word, wasFound: wordPlayed.found)
          }
        }
        .frame(maxHeight: .infinity)
        
        NavigationLink(
          destination: ScoreboardScreen()
            .navigationBarHidden(true),
          isActive: $showScoreboard
        ) {
          SizedButton(
            text: "Suivant".uppercased(),
            invertColor: vm.shouldInvertColors,
            onClick: {
              vm.finishTurn()
              
              if vm.hasMoreWords {
                appState.popToTurnStart()
              } else {
                showScoreboard = true
              }
            }
          )
        }
        .isDetailLink(false)
      }
      .padding()
    }
  }
}

struct WordPlayedView: View {
  @EnvironmentObject var dimens: Dimens
  
  var word: WordModel
  var wasFound: Bool
  
  var body: some View {
    HStack {
      BodyTextView(text: word.word)
      
      Spacer()
      
      RoundIcon(
        systemName: wasFound ? "checkmark" : "xmark",
        backgroungColor: wasFound ? .greenColor : .redColor,
        size: 24
      )
    }
    .padding(.horizontal, dimens.paddingMedium)
    .padding(.vertical, dimens.paddingSmall)
  }
}

struct TurnEndScreen_Previews: PreviewProvider {
  static var previews: some View {
    TurnEndScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
      .environmentObject(AppState())
    
    WordPlayedView(
      word: WordModel(word: "Octopus", category: .animals),
      wasFound: true
    )
    .environmentObject(Dimens())
    .previewLayout(.fixed(width: 400, height: 32))
  }
}
