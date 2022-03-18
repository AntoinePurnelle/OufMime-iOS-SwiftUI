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

  var body: some View {
    NavigationView {
      List {
        ForEach(vm.words) { item in
          NavigationLink {
            Text("Item at \(item.word)")
          } label: {
            Text(item.word + " " + item.category.rawValue)
          }
        }
      }
        .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: {
            vm.fetchWords()
          }) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      Text("Select an item")
    }
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
