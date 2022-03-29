//
//  WordViewModel.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import Foundation
import SwiftUI

typealias PlayedWord = (word: WordModel, found: Bool)

class WordsViewModel: ObservableObject {
  private var repo: WordRepository!
  
  // Game Settings
  @Published public var timerTotalTime = 40
  @Published public var timerCurrentValue = 40
  @Published public var wordsCount = 40
  @Published public var categories =  Category.allCases.map { SelectableCategory(id: $0, selected: true) }
  private var selectedCategories: [String] {
    get {
      categories.filter { selectableCategory in
        selectableCategory.selected
      }.map { selectedCategory in
        selectedCategory.id.rawValue
      }
    }
  }
  
  // Game Variables
  public private(set) var currentTeam = -1
  public private(set) var currentRound = 0
  private var currentRoundFinished = true
  @Published public private(set) var words = [WordModel] ()
  private var teamWords: [[[WordModel]]] = [
    [[WordModel](), [WordModel](), [WordModel]()],
    [[WordModel](), [WordModel](), [WordModel]()],
  ]
  
  public private(set) var wordsToPlay = [WordModel]()
  private var wordsMissedInRound = [WordModel]()
  @Published public private(set) var wordsPlayedInTurn: [PlayedWord] = []
  
  @Published public private(set) var currentWord: WordModel? = nil
  
  
  init() {
    repo = WordRepositoryImpl()
    insertWords()
  }
}

// Getters/Setters Extension
extension WordsViewModel {
  
  var hasMoreWords: Bool {
    get { wordsToPlay.count > 0 }
  }
  
  var hasMoreRounds: Bool {
    get { currentRound < 2 }
  }
  
  func getScore(inRound round: Int, forTeam team: Int) -> Int {
    return currentRound < round ? -1 : teamWords[team][round].count
  }
  
  func getCurrentRoundScore(forTeam team: Int) -> Int {
    return getScore(inRound: currentRound, forTeam: team)
  }
  
  func getTotalScore(forTeam team: Int) -> Int {
    return teamWords[team].reduce(0) { count, words in
      count + words.count
    }
  }
  
  var wordsFoundInTurnCount: Int {
    get { wordsPlayedInTurn.filter { (_, found) in found }.count }
  }
  
  var wordsMissedInTurnCount: Int {
    get { wordsPlayedInTurn.filter { (_, found) in !found }.count }
  }
  
  func editGamesSettings(withWordsCount wordsCount: Int, turnDuration seconds: Int) {
    self.wordsCount = wordsCount
    self.timerTotalTime = seconds
  }
  
  func changeValueInPlayedWords(atRow index: Int) {
    wordsPlayedInTurn[index].found.toggle()
  }
  
  var shouldInvertColors: Bool {
    get { currentTeam == 0 }
  }
  
  func getColor(forteam team: Int) -> Color {
    switch (team) {
    case 0: return .accentColor
    case 1: return .primaryColor
    default: return .white
    }
  }
  
}

// Game LifeCycle Extensions
extension WordsViewModel {
  
  func initGame(onCompleted: @escaping (() -> Void)) {
    repo.fetchRandomWords(inCategories: selectedCategories, withCount: wordsCount, inLanguage: Locale.current.languageCode!) { words in
      self.words = words
      print("Selected Words: \(words)")
      
      currentRound = 0
      currentTeam = 0
      
      teamWords = [
        [[WordModel](), [WordModel](), [WordModel]()],
        [[WordModel](), [WordModel](), [WordModel]()],
      ]
      
      DispatchQueue.main.async {
        onCompleted()
      }
      
    } onError: { message in
      debugPrint(message)
    }
  }
  
  func initRound() {
    currentRoundFinished = false
    wordsToPlay.removeAll()
    wordsToPlay.append(contentsOf: words.shuffled())
    wordsMissedInRound.removeAll()
    
    print("Starting round \(currentRound) - Words to Play (\(wordsToPlay.count)): \(wordsToPlay)")
  }
  
  func initTurn() {
    wordsPlayedInTurn.removeAll()
    currentWord = wordsToPlay.first
    timerCurrentValue = timerTotalTime
  }
  
  func playWord(wasFound: Bool, timerEnded: Bool = false) {
    if hasMoreWords {
      wordsPlayedInTurn.append((wordsToPlay.removeFirst(), wasFound))
      
      debugPrint("Played word \(wordsPlayedInTurn.last!)")
      
      if !timerEnded {
        currentWord = wordsToPlay.first
      }
    }
  }
  
  func finishTurn() {
    let wordsFoundInTurn = wordsPlayedInTurn.filter { (word, found) in found }.map { (word, _) in word }
    teamWords[currentTeam][currentRound].append(contentsOf: wordsFoundInTurn)
    
    let wordsMissedInTurn = wordsPlayedInTurn.filter { (word, found) in !found }.map { (word, _) in word }
    wordsToPlay.append(contentsOf: wordsMissedInTurn)
    
    currentTeam = currentTeam == 0 ? 1 : 0
    
    debugPrint("Turn finished and saved")
  }
  
  func finishRound() {
    currentRound += 1
    initRound()
  }
  
}


// DB Extensions
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
      
      insertLanguageWords(language: "en", words: words.en)
      insertLanguageWords(language: "fr", words: words.fr)
      
      wordsListVersion = words.version
      
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
  
  func insertLanguageWords(language: String, words: TranslatedWords) {
    insert(words: words.actions, in: .actions, language: language)
    insert(words: words.activities, in: .activities, language: language)
    insert(words: words.anatomy, in: .anatomy, language: language)
    insert(words: words.animals, in: .animals, language: language)
    insert(words: words.celebrities, in: .celebrities, language: language)
    insert(words: words.clothes, in: .clothes, language: language)
    insert(words: words.events, in: .events, language: language)
    insert(words: words.fictional, in: .fictional, language: language)
    insert(words: words.food, in: .food, language: language)
    insert(words: words.geek, in: .geek, language: language)
    insert(words: words.locations, in: .locations, language: language)
    insert(words: words.jobs, in: .jobs, language: language)
    insert(words: words.mythology, in: .mythology, language: language)
    insert(words: words.nature, in: .nature, language: language)
    insert(words: words.objects, in: .objects, language: language)
    insert(words: words.vehicles, in: .vehicles, language: language)
  }
  
  func insert(words: [String], in category: Category, language: String) {
    
    let wordEntities = words.map { word in
      WordModel(word: word, category: category, language: language)
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
