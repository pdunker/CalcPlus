//
//  ViewController.swift
//  Calculator
//
//  Created by Philip 2023.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var m_screenLabel: UILabel!
    
    var m_calc: CalcController?
    
    override func viewDidLoad ()
    {
        super.viewDidLoad()
        m_calc = CalcController()
    }
    
    @IBAction func buttonPressed (_ sender: UIButton)
    {
        let str = sender.titleLabel!.text!
        let input = str.trimmingCharacters(in: .whitespaces)
        m_calc!.Input(input: input)
        m_screenLabel.text = m_calc?.GetCurrCalc()
    }
}

