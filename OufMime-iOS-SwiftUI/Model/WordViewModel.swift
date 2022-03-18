//
//  WordViewModel.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import Foundation

class WordsViewModel: ObservableObject {
  private var repo: WordRepository!
  @Published var words = [WordModel]()
  
  init() {
    repo = WordRepositoryImpl()
    insertWords()
  }
  
  func fetchWords() {
    repo.fetchRandomWords(inCategories: Category.allCases.map({ category in
      category.rawValue
    }), withCount: 10) { words in
      self.words = words
    } onError: { message in
      debugPrint(message)
    }
  }
}


extension WordsViewModel {
  
  private var wordsListVersion: Int {
    get {
      UserDefaults.standard.integer(forKey: "wordsListVersion")
    }
    set {
      let ud = UserDefaults.standard
      ud.set(newValue, forKey: "wordsListVersion")
      ud.synchronize()
    }
  }
  
  func insertWords() {
    guard let path = Bundle.main.path(forResource: "words", ofType: "json") else { return }
    do {
      let jsonData = try String(contentsOfFile: path).data(using: .utf8)
      let words = try JSONDecoder().decode(Words.self, from: jsonData!)
      
      if wordsListVersion == words.version {
        return
      }
      
      insert(words: words.actions, in: .actions)
      insert(words: words.activities, in: .activities)
      insert(words: words.anatomy, in: .anatomy)
      insert(words: words.animals, in: .animals)
      insert(words: words.celebrities, in: .celebrities)
      insert(words: words.clothes, in: .clothes)
      insert(words: words.events, in: .events)
      insert(words: words.fictional, in: .fictional)
      insert(words: words.food, in: .food)
      insert(words: words.geek, in: .geek)
      insert(words: words.locations, in: .locations)
      insert(words: words.jobs, in: .jobs)
      insert(words: words.mythology, in: .mythology)
      insert(words: words.nature, in: .nature)
      insert(words: words.objects, in: .objects)
      insert(words: words.vehicles, in: .vehicles)
      
      wordsListVersion = words.version
      
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
  
  func insert(words: [String], in category: Category) {
    
    let wordEntities = words.map { word in
      WordModel(word: word, category: category)
    }
    
    repo.insert(words: wordEntities, onCompleted: {
      repo.fetchAllWords { words in
        print(words)
        //self.words = words
      } onError: { message in
        debugPrint(message)
      }
      
    }) { message in
      debugPrint(message)
    }
  }
  
}
