//
//  Fundation.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import Foundation

enum Category: String, Codable, CaseIterable {
  
  case actions = "actions"
  case activities = "activities"
  case anatomy = "anatomy"
  case animals = "animals"
  case celebrities = "celebrities"
  case clothes = "clothes"
  case events = "events"
  case fictional = "fictional"
  case food = "food"
  case geek = "geek"
  case jobs = "jobs"
  case locations = "locations"
  case mythology = "mythology"
  case nature = "nature"
  case objects = "objects"
  case vehicles = "vehicles"
  
}

struct SelectableCategory: Identifiable {
  var id: Category
  var selected: Bool
}
