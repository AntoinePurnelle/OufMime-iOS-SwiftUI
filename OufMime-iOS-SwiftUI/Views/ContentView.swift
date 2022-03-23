//
//  ContentView.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @StateObject var vm = WordsViewModel()
  @ObservedObject var appState = AppState()
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  var body: some View {
    NavigationView {
      WelcomeScreen()
      .id(appState.welcomeScreenId)
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .environmentObject(vm)
    .environmentObject(Dimens(isLarge: horizontalSizeClass == .regular))
    .environmentObject(appState)
  }
  
  private func addItem() {
    withAnimation {
      vm.insert(words: ["Test"], in: Category.allCases.shuffled().first!)
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
        .previewDevice("iPhone 13")
      ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPad Pro (9.7-inch)")
    }
  }
}


final class AppState: ObservableObject {
  @Published var welcomeScreenId = UUID()
  @Published var turnStartScreenId = UUID()
  
  func popToTurnStart() {
    turnStartScreenId = UUID()
  }
  
  func popToWelcome() {
    welcomeScreenId = UUID()
  }
}
