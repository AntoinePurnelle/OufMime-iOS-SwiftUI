//
//  OufMime_iOS_SwiftUITests.swift
//  OufMime-iOS-SwiftUITests
//
//  Created by Antoine Purnelle on 17/03/2022.
//

import XCTest
@testable import OufMime_iOS_SwiftUI

class OufMime_iOS_SwiftUITests: XCTestCase {

  private var vm: WordsViewModel!

  override func setUpWithError() throws {
    vm = WordsViewModel()
    vm.editGamesSettings(withWordsCount: 4, turnDuration: 10.0)
    vm.initGame {
    }
  }

  override func tearDownWithError() throws {
    vm = nil
  }

  func testGameInit() throws {
    XCTAssertEqual(vm.currentTeam, 0)
    XCTAssertEqual(vm.currentRound, 0)
  }

  func testTurnInit() {
    XCTAssertEqual(vm.currentTeam, 0)
    XCTAssertEqual(vm.currentRound, 0)
    XCTAssertFalse(vm.hasMoreWords)

    vm.initRound()
    vm.initTurn()

    XCTAssertEqual(vm.wordsPlayedInTurn.count, 0)
    XCTAssertNotNil(vm.currentWord)
    XCTAssertTrue(vm.hasMoreWords)
  }

  func testFullRound() {
    // ROUND 1
    vm.initRound()
    XCTAssertEqual(vm.wordsToPlay.count, 4)
    
    // ROUND 1 TEAM 1
    vm.initTurn()
    vm.playWord(wasFound: true, timerEnded: false)
    vm.playWord(wasFound: false, timerEnded: false)
    vm.playWord(wasFound: false, timerEnded: true)
    vm.finishTurn()

    print(vm.getScore(inRound: 0, forTeam: 0))

    XCTAssertEqual(vm.getScore(inRound: 0, forTeam: 0), 1)
    XCTAssertEqual(vm.getTotalScore(forTeam: 0), 1)
    XCTAssertEqual(vm.getCurrentRoundScore(forTeam: 0), 1)

    XCTAssertEqual(vm.getScore(inRound: 0, forTeam: 1), 0)
    XCTAssertEqual(vm.getTotalScore(forTeam: 1), 0)
    XCTAssertEqual(vm.getCurrentRoundScore(forTeam: 1), 0)

    XCTAssertEqual(vm.wordsFoundInTurnCount, 1)
    XCTAssertEqual(vm.wordsMissedInTurnCount, 2)
    XCTAssertEqual(vm.wordsPlayedInTurn.count, 3)

    XCTAssertEqual(vm.currentTeam, 1)
    XCTAssertEqual(vm.wordsToPlay.count, 3)
    
    // ROUND 1 TEAM 2

    vm.initTurn()
    vm.playWord(wasFound: true, timerEnded: false)
    vm.playWord(wasFound: false, timerEnded: false)
    vm.playWord(wasFound: true, timerEnded: false)
    vm.changeValueInPlayedWords(atRow: 1)
    vm.finishTurn()

    XCTAssertEqual(vm.getScore(inRound: 0, forTeam: 0), 1)
    XCTAssertEqual(vm.getTotalScore(forTeam: 0), 1)
    XCTAssertEqual(vm.getCurrentRoundScore(forTeam: 0), 1)

    XCTAssertEqual(vm.getScore(inRound: 0, forTeam: 1), 3)
    XCTAssertEqual(vm.getTotalScore(forTeam: 1), 3)
    XCTAssertEqual(vm.getCurrentRoundScore(forTeam: 1), 3)

    XCTAssertEqual(vm.wordsFoundInTurnCount, 3)
    XCTAssertEqual(vm.wordsMissedInTurnCount, 0)
    XCTAssertEqual(vm.wordsPlayedInTurn.count, 3)
    
    XCTAssertEqual(vm.currentTeam, 0)
    XCTAssertEqual(vm.wordsToPlay.count, 0)
    
    vm.finishRound()
    
    // ROUND 2
    vm.initRound()
    
    XCTAssertEqual(vm.currentRound, 1)
    XCTAssertEqual(vm.wordsToPlay.count, 4)
    
    XCTAssertEqual(vm.getCurrentRoundScore(forTeam: 0), 0)
    XCTAssertEqual(vm.getCurrentRoundScore(forTeam: 1), 0)
  }

}
