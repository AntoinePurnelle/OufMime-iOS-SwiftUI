//
//  HeaderView.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 21/03/2022.
//

import SwiftUI

struct HeaderView: View {
  @EnvironmentObject var dimens: Dimens
  
  var team1TotalScore: Int
  var team1RoundScore: Int
  var team2TotalScore: Int
  var team2RoundScore: Int
  var invertColors: Bool
  
  var body: some View {
    HStack(spacing: dimens.paddingXLarge) {
      
      ScoreboardView(
        topLabel: "Total",
        topScore: team1TotalScore,
        bottomLabel: "Round",
        bottomScore: team1RoundScore,
        color: .accentColor
      )
      
      AppIcon(inverted: true)
        .frame(width: dimens.iconMedium, height: dimens.iconMedium)
      
      ScoreboardView(
        topLabel: "Total",
        topScore: team2TotalScore,
        bottomLabel: "Round",
        bottomScore: team2RoundScore,
        color: .primaryColor
      )
      
    }
    .padding(dimens.paddingLarge)
    .background(
      RoundedRectangle(
        cornerRadius: dimens.cornerRadiusLarge
      )
      .fill(Color.white)
    )
  }
}

struct ScoreboardView: View {
  @EnvironmentObject var dimens: Dimens
  
  var topLabel: String
  var topScore: Int
  var bottomLabel: String
  var bottomScore: Int
  var color: Color
  
  var body: some View {
    VStack {
      ScoreLineView(scoreName: topLabel, score: topScore, color: color)
      ScoreLineView(scoreName: bottomLabel, score: bottomScore, color: color)
    }
    .padding(dimens.paddingMedium)
    .background(
      RoundedRectangle(cornerRadius: dimens.cornerRadiusMedium)
        .strokeBorder(color, lineWidth: dimens.borderSmall)
    ).frame(maxWidth: dimens.simpleScoreboardWidth)
  }
}

struct ScoreLineView: View {
  @EnvironmentObject var dimens: Dimens
  
  var scoreName: String
  var score: Int
  var color: Color
  
  var body: some View {
    let scoreText = score == -1 ? "--" : String(score)
    
    HStack() {
      BodyTextView(
        text: scoreName,
        color: color
      )
      
      Spacer()
      
      BodyTextView(
        text: scoreText,
        color: color
      )
    }
  }
}

struct Scoreboard_Previews: PreviewProvider {
  static var previews: some View {
    
    VStack(alignment: .center, spacing: 10) {
      HeaderView(team1TotalScore: 42, team1RoundScore: 9, team2TotalScore: 24, team2RoundScore: 4, invertColors: true)
      ScoreboardView(topLabel: "Total", topScore: 42, bottomLabel: "Round", bottomScore: 9, color: .primaryColor)
        .frame(width: 100)
      ScoreLineView(scoreName: "Total", score: 42, color: .primaryColor)
        .frame(width: 100)
    }
    .environmentObject(Dimens())
    .padding()
    .background(Color.accentColor)
    .previewLayout(.fixed(width: 500, height: 320))
  }
}
