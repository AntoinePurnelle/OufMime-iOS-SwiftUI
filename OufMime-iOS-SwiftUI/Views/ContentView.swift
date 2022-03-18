//
//  ContentView.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @State var hasGameStarted = false
  @State var isShowingSettings = false
  @StateObject var vm = WordsViewModel()
  @StateObject var dimens = Dimens()
  
  var body: some View {
    NavigationView {
      WelcomeScreen(hasGameStarted: $hasGameStarted, isShowingSettings: $isShowingSettings)
    }
    .environmentObject(vm)
    .environmentObject(dimens)
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
