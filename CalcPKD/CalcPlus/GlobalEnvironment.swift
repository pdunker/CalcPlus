//
//  GlobalEnvironment.swift
//  CalcPlus
//
//  Created by Philip Dunker on 30/01/23.
//

import SwiftUI
import AVFoundation

struct ElementsSizes {
  var btnsTextSize: CGFloat
  var dispTextSize: CGFloat
  var funcBtnImageSize: CGFloat
  var sizeRatio: CGFloat
}

struct InputResult {
  var currCalc: String = ""
  var lastCalc: String = ""
  var sound: String = ""
  var accepted: Bool = false
}

// workaround to the old calcs (historic) dont start at the top
let oldCalcsDefault: [String] = ["", "", "", "", "", "", ""]

// Env object
// You can treat this as the Global Application State
class GlobalEnvironment: ObservableObject {
  
  @Published var soundOn = false // TODO: TURN ON BEFORE DEPLOYING
  
  @Published var currentSize = "Small"
  @Published var elemSizes: ElementsSizes = ElementsSizes(btnsTextSize: 34, dispTextSize: 44, funcBtnImageSize: 24, sizeRatio: 0.9)
  
  @Published var darkMode = true;
  @Published var backColor: Color = .black
  @Published var textColor: Color = .white
  
  @Published var oldCalcs: [String] = oldCalcsDefault
  @Published var display = ""
  
  @Published var scrollToLast = 0
  
  let calculator = CalculatorModule()
  
  private var audioPlayer: AVAudioPlayer?
  
  init() {
    PlaySound(sound: "start")
    SetFontSize(option: currentSize)
  }
  
  func SetFontSize (option: String) {
    if option == "Small" {
      elemSizes.btnsTextSize = 34
      elemSizes.dispTextSize = 44
      elemSizes.funcBtnImageSize = 24
      elemSizes.sizeRatio = 0.9
    } else if option == "Medium" {
      elemSizes.btnsTextSize = 46
      elemSizes.dispTextSize = 56
      elemSizes.funcBtnImageSize = 30
      elemSizes.sizeRatio = 0.95
    }
    else if option == "Big" {
      elemSizes.btnsTextSize = 56
      elemSizes.dispTextSize = 70
      elemSizes.funcBtnImageSize = 36
      elemSizes.sizeRatio = 1
    }
  }
  
  func Input (button: CalcButton) {
    if button == .sound {
      if soundOn {
        PlaySound(sound: "sound_off")
      }
      soundOn = !soundOn
      if soundOn {
        PlaySound(sound: "sound_on")
      }
      return
    }
    if button == .like {
      PlaySound(sound: "yay")
      RateButtonPressed()
      return
    }
    if button == .eraser {
      PlaySound(sound: "trash")
      oldCalcs = oldCalcsDefault
      return
    }
    if button == .theme {
      darkMode = !darkMode
      if darkMode {
        backColor = .black
        textColor = .white
      } else {
        backColor = .white
        textColor = .black
      }
      return
    }

    let result = calculator.Input(input: button.title)
    
    if !result.sound.isEmpty {
      PlaySound(sound: result.sound)
    }
    
    if !result.lastCalc.isEmpty {
      self.oldCalcs.append(result.lastCalc)
    }
    
    self.display = result.currCalc
    scrollToLast += 1
  }
  
  func PlaySound(sound: String) {
    if soundOn == false {
      return
    }
    guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
      print("Sound file \(sound) not found!") // show alert
      return
    }
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      guard let player = audioPlayer else {
        print("Couldn't setup AVAudioPlayer!")  // show alert
        soundOn = false
        return
      }
      player.play()
    }
    catch let error {
      soundOn = false
      print(error.localizedDescription)
    }
  }
  
  func ShowAlert() {
    /*
     TODO: Rever a função de exibir alertas
     
     //How to Show an Alert in Swift
     // https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
     let dialogMessage = UIAlertController(title: "Rate CalcPKD", message: "Are you sure you want to delete this?", preferredStyle: .alert)
     // Create OK button with action handler
     let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
     print("Ok button tapped")
     })
     // Create Cancel button with action handlder
     let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
     print("Cancel button tapped")
     }
     //Add OK and Cancel button to an Alert object
     dialogMessage.addAction(ok)
     dialogMessage.addAction(cancel)
     // Present alert message to user
     self.present(dialogMessage, animated: true, completion: nil)
     */
  }
  
  private func RateButtonPressed() {
    AppStoreReviewManager.requestReviewIfAppropriate()
  }
}
