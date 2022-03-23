//
//  SettingsScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 18/03/2022.
//

import SwiftUI
import Combine

struct SettingsScreen: View {
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  
  @State var turnDuration: String = "40"
  @State var wordsCount: String = "40"
  
  var body: some View {
    
    return VStack(spacing: dimens.paddingXLarge) {
      
      SettingsTextField(label: "Durée des tours (s)", value: $vm.timerTotalTime)
      
      SettingsTextField(label: "Nombre de mots", value: $vm.wordsCount)
      
      ScrollView {
        ForEach($vm.categories) { selectableCategory in
          Toggle(selectableCategory.id.rawValue, isOn: selectableCategory.selected)
        }.padding()
      }
      
      SizedButton(text: "Back", textSize: .big) {
        appState.popToWelcome()
      }
    }
    .padding()
  }
}

struct SettingsTextField: View {
  var label: String
  @Binding var value: Int
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
      TextField(
        label,
        text: Binding(
          get: { String(value) },
          set: { value = Int($0.filter { "0123456789".contains($0) }) ?? value }
        )
      )
      .keyboardType(.numberPad)
      .textFieldStyle(RoundedBorderTextFieldStyle())
    }
  }
}

struct CategoryCheckbox: View {
  @EnvironmentObject var dimens: Dimens
  
  var category: Category
  var isChecked: Bool
  
  var body: some View {
    HStack {
      
    }
  }
  
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingsScreen()
      .environmentObject(Dimens())
      .environmentObject(AppState())
      .environmentObject(WordsViewModel())
  }
}
