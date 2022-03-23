//
//  PlayScreen.swift
//  OufMime-iOS-SwiftUI
//
//  Created by Antoine Purnelle on 21/03/2022.
//

import SwiftUI
import AVFoundation

struct PlayScreen: View {
  @EnvironmentObject var vm: WordsViewModel
  @EnvironmentObject var dimens: Dimens
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State var player: AVAudioPlayer? = nil
  @State var timerPlayer: AVAudioPlayer? = nil
  @State var showTurnEndScreen = false
  
  var body: some View {
    let background = vm.shouldInvertColors ? Color.accentColor : Color.primaryColor
    
    ZStack {
      background
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        HStack {
          ScoreboardView(
            topLabel: "Trouvés",
            topScore: vm.wordsFoundInTurnCount,
            bottomLabel: "Manqués",
            bottomScore: vm.wordsMissedInTurnCount,
            color: .white)
          .frame(maxWidth: .infinity)
          
          TimerView(
            value: $vm.timerCurrentValue,
            maxValue: vm.timerTotalTime,
            invertColors: vm.shouldInvertColors
          )
          .frame(maxWidth: .infinity)
          .onReceive(timer) { value in
            vm.timerCurrentValue -= 1
            
            if vm.timerCurrentValue == 4 {
              play(sound: "timer.wav", isTimerSound: true)
            }
            
            if vm.timerCurrentValue <= 0 {
              play(sound: "times_up.wav")
              timer.upstream.connect().cancel()
              vm.playWord(wasFound: false, timerEnded: true)
              showTurnEndScreen = true
            }
          }
        }
        .frame(maxHeight: .infinity)
        
        WordCardView(word: vm.currentWord)
          .frame(maxHeight: .infinity)
        
        HStack {
          RoundIconButton(
            systemName: "checkmark",
            backgroungColor: .greenColor
          ) {
            playWord(wasFound: true)
          }
          .frame(maxWidth: .infinity)
          
          RoundIconButton(
            systemName: "xmark",
            backgroungColor: .redColor
          ) {
            playWord(wasFound: false)
          }
          .frame(maxWidth: .infinity)
          
          NavigationLink(
            destination: TurnEndScreen()
              .navigationBarHidden(true),
            isActive: $showTurnEndScreen
          ) { }
            .isDetailLink(false)
        }
        .padding(.horizontal, horizontalSizeClass == .regular ?  200 : 0)
        .frame(maxHeight: .infinity)
      }
      .padding(20)
    }
  }
  
  func playWord(wasFound: Bool) {
    play(sound: wasFound ? "word_ok.wav" : "word_wrong.wav")
    vm.playWord(wasFound: wasFound)
    
    if !vm.hasMoreWords {
      showTurnEndScreen = true
      timer.upstream.connect().cancel()
    }
  }
  
  func play(sound soundName: String, isTimerSound: Bool = false) {
    guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
      return
    }
    
    let url = URL(fileURLWithPath: path)
    let queue = DispatchQueue(label: "timer")
    
    queue.async {
      do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        
        try AVAudioSession.sharedInstance().setActive(true)
        
        if isTimerSound {
          timerPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
          timerPlayer!.play()
        } else {
          player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
          player!.play()
        }
      } catch {
        debugPrint(error.localizedDescription)
      }
    }
  }
}

struct TimerView: View {
  @EnvironmentObject var dimens: Dimens
  @Binding var value: Int
  
  var maxValue: Int
  var invertColors: Bool
  
  var body: some View {
    let color = invertColors ? Color.primaryColor : Color.accentColor
    
    ZStack {
      Circle()
        .stroke(lineWidth: dimens.timerPathStrokeWidth)
        .foregroundColor(.whiteTransarentColor)
      
      Circle()
        .trim(
          from: 0.0,
          to: CGFloat(value) / CGFloat(maxValue))
        .stroke(style: StrokeStyle(
          lineWidth: dimens.timerStrokeWidth,
          lineCap: .round,
          lineJoin: .round)
        )
        .foregroundColor(color)
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.linear, value: value)
      
      BigTitleTextView(text: String(value), color: color)
    }
    .frame(width: dimens.timerSize, height: dimens.timerSize)
    .padding()
  }
}

struct WordCardView: View {
  @EnvironmentObject var dimens: Dimens
  
  var word: WordModel?
  
  var body: some View {
    VStack(spacing: 8) {
      if let word = word {
        TitleTextView(
          text: word.word,
          color: .accentColor
        )
        Text(word.category.rawValue)
          .font(.custom(Constants.font, size: dimens.subtitleText))
          .multilineTextAlignment(.center)
          .foregroundColor(.accentColor)
      }
    }
    .padding()
    .frame(maxWidth: 800, minHeight: 200)
    .background(
      RoundedRectangle(cornerRadius: dimens.cornerRadiusLarge)
        .fill(Color.white)
    )
    .padding()
  }
}

struct PlayScreen_Previews: PreviewProvider {
  static var previews: some View {
    PlayScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
      .previewDevice("iPhone 13")
    
    PlayScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens(isLarge: true))
      .previewInterfaceOrientation(.landscapeLeft)
      .previewDevice("iPad Pro (9.7-inch)")
    
    TimerView(value: Binding.constant(40), maxValue: 60, invertColors: false)
      .environmentObject(Dimens())
      .previewLayout(.fixed(width: 120, height: 120))
      .background(Color.primaryColor)
    
    WordCardView(word: WordModel(word: "Octopus", category: .animals))
      .environmentObject(Dimens())
      .previewLayout(.fixed(width: 400, height: 220))
      .background(Color.primaryColor)
  }
}
