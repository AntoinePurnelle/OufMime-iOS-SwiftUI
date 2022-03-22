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
  @EnvironmentObject var appState: AppState
  
  @State var timerCurrentValue: Int = 10
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State var player: AVAudioPlayer? = nil
  @State var timerPlayer: AVAudioPlayer? = nil
  
  
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
          
          TimerView(
            value: $timerCurrentValue,
            maxValue: vm.wordsCount,
            invertColors: vm.shouldInvertColors
          )
          .onReceive(timer) { _ in
            timerCurrentValue -= 1
            
            if timerCurrentValue == 4 {
              play(sound: "timer.wav", isTimerSound: true)
            }
            
            if timerCurrentValue == 0 {
              play(sound: "times_up.wav")
              timer.upstream.connect().cancel()
              vm.playWord(wasFound: false, timerEnded: true)
            }
          }
        }
      }
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
        
        if (isTimerSound) {
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
      
      Text(String(value))
        .font(.custom(Constants.font, size: dimens.bigTitleText))
        .foregroundColor(color)
    }
    .frame(width: dimens.timerSize, height: dimens.timerSize)
    .padding()
  }
}

struct PlayScreen_Previews: PreviewProvider {
  static var previews: some View {
    PlayScreen()
      .environmentObject(WordsViewModel())
      .environmentObject(Dimens())
      .environmentObject(AppState())
    
    TimerView(value: Binding.constant(40), maxValue: 60, invertColors: false)
      .environmentObject(Dimens())
      .previewLayout(.fixed(width: 120, height: 120))
      .background(Color.primaryColor)
  }
}
