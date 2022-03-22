//
//  WordViewModel.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import Foundation

typealias PlayedWord = (word: WordModel, found: Bool)

class WordsViewModel: ObservableObject {
  private var repo: WordRepository!
  
  // Game Settings
  public private(set) var timerTotalTime: Int = 10
  public private(set) var wordsCount = 10
  public var categories = Dictionary(uniqueKeysWithValues: Category.allCases.map { ($0.rawValue, true) })
  private var selectedCategories: [String] {
    get {
      categories.filter { (_, isSelected) in
        isSelected
      }.map { (category, _) in
        category
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

// Getters/Setters Extension
extension WordsViewModel {
  
  var hasMoreWords: Bool {
    get { wordsToPlay.count > 0 }
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
  
  var currentTeamName: String {
    get { currentTeam == 0 ? "Les Bleus" : "Les Oranges" }
  }
  
}

// Game LifeCycle Extensions
extension WordsViewModel {
  
  func initGame(onCompleted: @escaping (() -> Void)) {
    repo.fetchRandomWords(inCategories: selectedCategories, withCount: wordsCount) { words in
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
