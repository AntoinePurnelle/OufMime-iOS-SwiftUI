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
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  var body: some View {
    let background = vm.shouldInvertColors ? Color.accentColor : Color.primaryColor
    
    UITableView.appearance().backgroundColor = .clear
    
    return ZStack {
      background
        .edgesIgnoringSafeArea(.all)
      
      VStack(spacing: dimens.paddingLarge) {
        
        if horizontalSizeClass == .regular {
          TabletTurnEndView()
        } else {
          PhoneTurnEndView()
        }
        
        NavigationLink(
          destination: ScoreboardScreen()
            .navigationBarHidden(true),
          isActive: $showScoreboard
        ) {
          SizedButton(
            text: "next",
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

struct PhoneTurnEndView: View {
  @EnvironmentObject var dimens: Dimens
  
  var body: some View {
    VStack(spacing: dimens.paddingLarge) {
      TurnEndScoreboardView()
      WordsListView()
    }
  }
}

struct TabletTurnEndView: View {
  var body: some View {
    HStack {
      Spacer()
      TurnEndScoreboardView()
      Spacer()
      WordsListView()
      Spacer()
    }
  }
}

struct WordsListView: View {
  @EnvironmentObject var vm: WordsViewModel
  
  var body: some View {
    List(0..<vm.wordsPlayedInTurn.count, id: \.self) { index in
      let wordPlayed = vm.wordsPlayedInTurn[index]
      
      Button(action: {
        vm.changeValueInPlayedWords(atRow: index)
      }) {
        WordPlayedView(word: wordPlayed.word, wasFound: wordPlayed.found)
      }
    }
    .frame(maxWidth: 600, maxHeight: .infinity)
  }
}

struct TurnEndScoreboardView: View {
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  
  var body: some View {
    VStack(spacing: dimens.paddingLarge) {
      AppIcon(inverted: vm.shouldInvertColors)
        .frame(width: dimens.iconLarge, height: dimens.iconLarge)
      
      ScoreboardView(
        topLabel: "found",
        topScore: vm.wordsFoundInTurnCount,
        bottomLabel: "missed",
        bottomScore: vm.wordsMissedInTurnCount,
        color: .white
      )
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
        size: dimens.iconSmall
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
      .previewDevice("iPhone 13")
      .environment(\.locale, .init(identifier: "fr"))
    
    TurnEndScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(AppState())
      .environmentObject(Dimens(isLarge: true))
      .previewInterfaceOrientation(.landscapeLeft)
      .previewDevice("iPad Pro (12.9-inch) (5th generation)")
      .environment(\.locale, .init(identifier: "en"))
    
    WordPlayedView(
      word: WordModel(word: "Octopus", category: .animals, language: "en"),
      wasFound: true
    )
    .environmentObject(Dimens())
    .previewLayout(.fixed(width: 400, height: 32))
  }
}
