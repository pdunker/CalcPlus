//
//  ViewController.swift
//  Calculator
//
//  Created by Philip 2023.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController
{

    @IBOutlet weak var m_screenLabel: UILabel!
    var m_calc: CalculatorModule?
    var m_player: AVAudioPlayer?
    var m_sound_on = false
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        m_calc = CalculatorModule()
        PlaySound(letter: "start")
    }
    
    @IBAction func CalcButtonPressed (_ sender: UIButton)
    {
        var str: String?
        if (sender.titleLabel!.text != nil)
        {
            str = sender.titleLabel!.text!
        }
        else if (sender.tag == 1)
        {
            str = "del"
        }
        
        if (str != nil)
        {
            let input = str!.trimmingCharacters(in: .whitespaces)
            let sound = m_calc!.Input(input: input)
            if (sound != nil)
            {
                PlaySound(letter: sound!)
            }
            m_screenLabel.text = m_calc?.GetCurrCalc()
        }
        else
        {
            print("Unknow action")
        }
    }
    
    @IBAction func ShowHistoric (_ sender: Any)
    {
        let historicVC = HistoricViewController()
        self.present(historicVC, animated: true, completion: nil)
    }
    
    @IBAction func RateButtonPressed ()
    {
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
    
    @IBAction func SoundButtonPressed (_ sender: UIButton)
    {
        m_sound_on = !m_sound_on
    }
    
    func PlaySound (letter: String)
    {
        if (m_sound_on == false)
        {
            return
        }
        guard 
            let url = Bundle.main.url(forResource: letter, withExtension: "mp3")
        else
        {
            return
        }
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            m_player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = m_player else { return }
            player.play()
        }
        catch let error
        {
            print(error.localizedDescription)
        }
    }
    
}

