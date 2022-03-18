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
  
  init(word: String, category: Category) {
    self.word = word
    self.category = category
  }
}

struct Words: Codable {
  let version: Int
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
