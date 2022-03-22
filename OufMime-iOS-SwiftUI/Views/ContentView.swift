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
  @StateObject var dimens = Dimens()
  @ObservedObject var appState = AppState()
  
  var body: some View {
    NavigationView {
      WelcomeScreen()
      .id(appState.welcomeScreenId)
    }
    .environmentObject(vm)
    .environmentObject(dimens)
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
    ContentView()
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
