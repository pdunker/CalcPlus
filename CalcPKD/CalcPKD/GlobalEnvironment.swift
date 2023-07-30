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
    
    @Published var oldCalcs: [String] = ["", "", "", "", ""] // workaround to the historic dont start at the top
    @Published var display = ""

    @Published var scrollToLast = 0
    
    let calculator = CalculatorModule()
    
    private var soundOn = false // TODO: TURN ON BEFORE DEPLOYING
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        PlaySound(sound: "start")
    }
    
    func Input(button: CalcButton) {
        if button == .sound {
            soundOn = !soundOn
            return
        }
        if button == .like {
            RateButtonPressed()
            return
        }
        
        if calculator.GetCurrState() == CalculatorModule.InputState.answer {
            self.oldCalcs.append(calculator.GetCurrCalc())
            display = ""
        }
        
        let sound = calculator.Input(input: button.title)
        if sound != nil {
            PlaySound(sound: sound!)
        }
        self.display = calculator.GetCurrCalc()
        scrollToLast += 1
    }
    
    func PlaySound(sound: String) {
        if soundOn == false {
            return
        }
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("Sound file \(sound) not found!") // show alert
            soundOn = false
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
