//
//  GlobalEnvironment.swift
//  CalculatorSwiftUILBTA
//
//  Created by Philip Dunker on 30/01/23.
//  Copyright © 2023 Lets Build That App. All rights reserved.
//

import SwiftUI
import AVFoundation

// Env object
// You can treat this as the Global Application State
class GlobalEnvironment: ObservableObject {
    
    @Published var display = ""

    @Published var scrollToLastInput = 0
    
    let calculator = CalculatorModule()
    
    var soundOn = true
    var audioPlayer: AVAudioPlayer?
    
    init(display: String = "", inputCount: Int = 0, soundOn: Bool = true, audioPlayer: AVAudioPlayer? = nil) {
        self.display = display
        self.scrollToLastInput = inputCount
        self.soundOn = soundOn
        self.audioPlayer = audioPlayer
        PlaySound(sound: "start")
    }
    
    func Input (button: CalcButton) {
        if button == .sound {
            soundOn = !soundOn
            return
        }
        if button == .like {
            RateButtonPressed()
            return
        }
        let sound = calculator.Input(input: button.title)
        if sound != nil {
            PlaySound(sound: sound!)
        }
        self.display = calculator.GetCurrCalc()
        scrollToLastInput += 1
    }
    
    func PlaySound (sound: String) {
        if soundOn == false {
            return
        }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = audioPlayer else { return }
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func RateButtonPressed () {
        AppStoreReviewManager.requestReviewIfAppropriate()
        /*
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
}
