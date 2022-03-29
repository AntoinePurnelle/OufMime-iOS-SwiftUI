//
//  WordModel.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import Foundation

class WordModel: Identifiable {
  var id = UUID()
  
  let word: String
  let category: Category
  let language: String
  
  init(word: String, category: Category, language: String) {
    self.word = word
    self.category = category
    self.language = language
  }
}

struct Words: Codable {
  let version: Int
  let en: TranslatedWords
  let fr: TranslatedWords
}

struct TranslatedWords: Codable {
  let actions: [String]
  let activities: [String]
  let anatomy: [String]
  let animals: [String]
  let celebrities: [String]
  let clothes: [String]
  let events: [String]
  let fictional: [String]
  let food: [String]
  let geek: [String]
  let jobs: [String]
  let locations: [String]
  let mythology: [String]
  let nature: [String]
  let objects: [String]
  let vehicles: [String]
}
