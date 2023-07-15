//
//  ViewController.swift
//  Calculator Layout iOS13
//
//  Created by Angela Yu on 01/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var m_currInput:InputState = InputState.blank
    var m_lastAnswer: String?
    
    @IBOutlet weak var m_screenLabel: UILabel!
    
    @IBAction func dotBtn(_ sender: UIButton) {
        if (m_currInput == InputState.dot || m_currInput == InputState.answer || m_currInput == InputState.operation) {
            return
        }
        if (m_currInput == InputState.blank) {
            assert(m_screenLabel.text == "")
            m_screenLabel.text = "0"
        }
        m_screenLabel.text = m_screenLabel.text! + "."
        m_currInput = InputState.dot
    }
    
    func numbersInitOk () -> Bool
    {
        if (m_currInput == InputState.answer) {
            clearInput()
        }
        return true
    }
    @IBAction func zeroBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "0"
        m_currInput = InputState.number
    }
    @IBAction func oneBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "1"
        m_currInput = InputState.number
    }
    @IBAction func twoBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "2"
        m_currInput = InputState.number
    }
    @IBAction func threeBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "3"
        m_currInput = InputState.number
    }
    @IBAction func fourBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "4"
        m_currInput = InputState.number
    }
    @IBAction func fiveBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "5"
        m_currInput = InputState.number
    }
    @IBAction func sixBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "6"
        m_currInput = InputState.number
    }
    @IBAction func sevenBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "7"
        m_currInput = InputState.number
    }
    @IBAction func eightBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "8"
        m_currInput = InputState.number
    }
    @IBAction func nineBtn(_ sender: UIButton) {
        if (numbersInitOk() == false) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "9"
        m_currInput = InputState.number
    }

    func operatorsInitOk (blank_valid: Bool) -> Bool
    {
        if (m_currInput == InputState.dot ||
            (!blank_valid && m_currInput == InputState.blank)) {
            return false
        }
        if (m_currInput == InputState.operation) {
            eraseLastInput()
            assert(m_currInput == InputState.number)
        }
        if (m_currInput == InputState.answer) {
            if (m_lastAnswer != nil) {
                clearInput()
                useAnswer()
            }
            else {
                // last calc was inf or NaN
                return false
            }
        }
        return true
    }
    
    @IBAction func divBtn(_ sender: UIButton) {
        if (operatorsInitOk(blank_valid: false) == false){
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "/"
        m_currInput = InputState.operation
    }
    
    @IBAction func multBtn(_ sender: UIButton) {
        if (operatorsInitOk(blank_valid: false) == false){
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "x"
        m_currInput = InputState.operation
    }
    
    @IBAction func minusBtn(_ sender: UIButton) {
        if (operatorsInitOk(blank_valid: true) == false){
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "-"
        m_currInput = InputState.operation
    }
    
    @IBAction func plusBtn(_ sender: UIButton) {
        if (operatorsInitOk(blank_valid: false) == false){
            return
        }
        m_screenLabel.text = m_screenLabel.text! + "+"
        m_currInput = InputState.operation
    }
    
    @IBAction func bsBtn(_ sender: UIButton) {
        if (m_screenLabel.text == "" || m_currInput == InputState.answer) {
            return
        }
        eraseLastInput()
    }
    
    @IBAction func ansBtn(_ sender: UIButton) {
        useAnswer()
    }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        clearInput()
    }
    
    @IBAction func equalBtn(_ sender: UIButton) {
        if (m_currInput == InputState.blank || m_currInput == InputState.answer || m_currInput == InputState.operation) {
            return
        }
        var numbers_array: [Double] = []
        var operators_array: [Character] = []
        var number_str: String?
        var max_precision = -1
        var last_state = InputState.blank

        for (index, char) in m_screenLabel.text!.enumerated() {
            print("index = \(index), char = \(char), isNumber = \(char.isNumber)")
            
            if (last_state == InputState.blank && char == "-") {
                number_str = "-"
                continue
            }
            
            let recog_state = recognizeState(input: String(char))
            print("recog_state: \(recog_state)")
            
            var try_recog_number = false
            
            if (recog_state == InputState.number || recog_state == InputState.dot) {
                last_state = recog_state
                number_str = (number_str ?? "") + String(char)
                if (index == m_screenLabel.text!.count-1) {
                    try_recog_number = true
                }
            }
            else if(recog_state == InputState.operation) {
                operators_array.append(char)
                try_recog_number = true
            }

            if (try_recog_number) {
                print("try_recog_number: \(number_str ?? "(nil)")")
                let number_dbl = Double(number_str!)
                if (number_dbl != nil) {
                    //print("double number \(number_dbl!)")
                    numbers_array.append(number_dbl!)
                    
                    var dot_index = 0
                    for (index2, num_char) in number_str!.enumerated() {
                        if (num_char == ".") {
                            dot_index = index2
                            //print("dot_index: \(dot_index)")
                            break
                        }
                    }
                    let total_precision = (number_str!.count - 1) - dot_index
                    print("precision: \(total_precision)")
                    if (max_precision < total_precision) {
                        max_precision = total_precision
                    }
                    number_str = nil
                    last_state = InputState.blank
                }
                else {
                    print("not recognized: \(number_str!)")
                }
            }
        }
        
        print("max_precision: \(max_precision)")
        print("numbers_array.count = \(numbers_array.count)")
        print(numbers_array)
        print("operators_array.count = \(operators_array.count)")
        print(operators_array)
        //assert(operators_array.count < numbers_array.count)
        

        //for (index, operation) in operators_array.enumerated() {
        var op_count = operators_array.count
        var index = 0
        repeat {
            let operation = operators_array[index]
            if (operation == "/" || operation == "x") {
                operators_array.remove(at:index)
                op_count -= 1
                var num_1 = numbers_array.remove(at:index)
                let num_2 = numbers_array.remove(at:index)
                print("priority: \(num_1) \(operation) \(num_2)")
                if (operation == "x") {
                    num_1 = num_1 * num_2
                }
                else if (operation == "/") {
                    num_1 = num_1 / num_2
                }
                print("result: \(num_1)")
                numbers_array.insert(num_1, at: index)
            }
            else {
                index += 1
            }
        } while (index < op_count)
        
        print("numbers_array.count = \(numbers_array.count)")
        print(numbers_array)
        print("operators_array.count = \(operators_array.count)")
        print(operators_array)
        
        var result = 0.0
        for (index, number) in numbers_array.enumerated() {
            if (index == 0) {
                result = number
                continue
            }
            let operation = operators_array[index-1]
            print("calculating: \(result) \(operation) \(number)")
            if (operation == "+") {
                result = result + number
            }
            else if (operation == "-") {
                result = result - number
            }
            else if (operation == "x") {
                result = result * number
            }
            else if (operation == "/") {
                result = result / number
            }
            print("result: \(result)")
        }

        let result_int = Int(exactly: result)
        if (result_int != nil) {
            m_lastAnswer = String(result_int!)
        }
        else {
            if (max_precision > 0) {
                let format = "%." + String(max_precision) + "f"
                print("format: \(format)")
                m_lastAnswer = String(format:format , result)
            }
            else {
                m_lastAnswer = String(result)
            }
        }
        m_screenLabel.text = m_screenLabel.text! + "=" + m_lastAnswer!
        m_currInput = InputState.answer
        if (result.isInfinite || result.isNaN) {
            m_lastAnswer = nil
        }
    }
    
    /**
     *  Utility Functions:
     */
    enum InputState {
        case blank
        case number
        case operation
        case equal
        case answer
        case dot
        case error // used for inf or nan
        case unknow
    }

    func eraseLastInput ()
    {
        let index = m_screenLabel.text!.index(m_screenLabel.text!.endIndex, offsetBy: -1)
        m_screenLabel.text = String(m_screenLabel.text![..<index])
        m_currInput = recognizeState(input: nil)
    }
    
    func clearInput ()
    {
        m_screenLabel.text = ""
        m_currInput = InputState.blank
    }
    
    func useAnswer ()
    {
        if (m_lastAnswer == nil || m_currInput == InputState.number || m_currInput == InputState.dot || m_currInput == InputState.answer) {
            return
        }
        m_screenLabel.text = m_screenLabel.text! + m_lastAnswer!
        m_currInput = InputState.number
    }
    
    func recognizeState (input:String?) -> InputState
    {
        var state = InputState.unknow
        var _input = input
        if (_input == nil) {
            if (m_screenLabel.text == "") {
                state = InputState.blank
            }
            else {
                let index = m_screenLabel.text!.index(m_screenLabel.text!.endIndex, offsetBy: -1)
                _input = String(m_screenLabel.text![index])
            }
        }
        if (state == InputState.unknow) {
            assert(_input != nil)
            if (_input == "0" ||
                _input == "1" ||
                _input == "2" ||
                _input == "3" ||
                _input == "4" ||
                _input == "5" ||
                _input == "6" ||
                _input == "7" ||
                _input == "8" ||
                _input == "9")
            {
                state = InputState.number
            }
            else if (_input == "+" ||
                     _input == "-" ||
                     _input == "x" ||
                     _input == "/" )
            {
                state = InputState.operation
            }
            else if (_input == ".")
            {
                state = InputState.dot
            }
            else if (_input == "=")
            {
                state = InputState.equal
            }
            else
            {
                print("recognizeState: \(_input ?? "(nil)")")
                state = InputState.error
            }
        }
        print("recognizeState() _input: \(_input ?? "(nil)") | state: \(state)")
        //assert(state != InputState.unknow)
        return state
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

