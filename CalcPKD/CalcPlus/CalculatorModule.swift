//
//  CalcController.swift
//  CalcPlus
//
//  Created by Philip Dunker on 16/07/23.
//


class CalculatorModule
{
  enum InputState
  {
    case blank
    case number
    case operation
    case equal
    case answer
    case dot
    case error // used for inf or nan
    case unknow
  }
  
  let Operators =
  [
    "MULT"  : "×",
    "DIV"   : "÷",
    "PLUS"  : "+",
    "MINUS" : "-",
  ]
  
  let InputReceived =
  [
    "NUMBER_OK"   : "digit",
    "OPERATOR_OK" : "digit",// "operator",
    "INVALID"     : "error",
    "EQUAL"       : "result",
    "DOT"         : "digit",
    "FUNCTION"    : "function",
    "AC"          : "start",
    "ERASER"      : "eraser",
    "LR"          : "digit",
  ]
  
  private var m_currCalc = ""
  
  private var m_lastInputState:InputState = InputState.blank
  
  private var m_lastAnswer: String?
  
  private var m_digitingNum = false   // variables used to avoid
  private var m_currNumHasDot = false // two dots in the same number
  
  func GetCurrCalc () -> String {
    return m_currCalc
  }
  
  func GetCurrState () -> InputState {
    return m_lastInputState
  }
  
  func Input (input: String) -> InputResult {
    var result = InputResult()
    if m_lastInputState == InputState.answer {
      result.lastCalc = m_currCalc
    }
    
    if input == "0" || input == "1" || input == "2" || input == "3" || input == "4" ||
       input == "5" || input == "6" || input == "7" || input == "8" || input == "9" {
      
      if m_lastInputState == InputState.answer {
        Clear()
      }
      m_currCalc = m_currCalc + input
      if m_lastInputState != InputState.number &&
         m_lastInputState != InputState.dot {
        m_digitingNum = true
        m_currNumHasDot = false
      }
      
      m_lastInputState = InputState.number
      result.sound = InputReceived["NUMBER_OK"]!
      result.accepted = true
      
    } else if input == "." {
      
      if m_lastInputState == InputState.dot ||
         m_digitingNum && m_currNumHasDot {
        
        result.sound = InputReceived["INVALID"]!
        
      } else {
        
        if m_lastInputState == InputState.blank ||
           m_lastInputState == InputState.answer {
          m_digitingNum = true
          m_currCalc = "0"
        }
        if m_lastInputState == InputState.operation {
          m_digitingNum = true
          m_currCalc = m_currCalc + "0"
        }
        m_currCalc = m_currCalc + "."
        m_lastInputState = InputState.dot
        m_currNumHasDot = true
        result.sound = InputReceived["DOT"]!
        result.accepted = true
      }
      
    } else {
      
      m_digitingNum = false
      
      if input == "LR" {
        
        if UseLastAnswer() {
          result.sound = InputReceived["LR"]!
          result.accepted = true
        } else {
          result.sound = InputReceived["INVALID"]!
        }
        
      } else if (input == Operators["PLUS" ] ||
                 input == Operators["MINUS"] ||
                 input == Operators["MULT" ] ||
                 input == Operators["DIV"  ]  )
      {
        let is_minus = (input == Operators["MINUS"])
        if !CanInputOperator(blank_valid: is_minus) {
          result.sound = InputReceived["INVALID"]!
        } else {
          m_currCalc = m_currCalc + input
          m_lastInputState = InputState.operation
          result.sound = InputReceived["OPERATOR_OK"]!
          result.accepted = true
        }
      } else if (input == "AC") {
        Clear()
        result.sound = InputReceived["AC"]!
        result.accepted = true
      } else if (input == "Del") {
        
        if m_currCalc == "" {
          result.sound = InputReceived["INVALID"]!
        } else {
          
          if m_lastInputState == InputState.answer {
            Clear()
          } else {
            EraseLastInput()
          }
          result.sound = InputReceived["ERASER"]!
          result.accepted = true
          
        }
      } else if input == "=" {
        
        if Equal() {
          result.sound = InputReceived["EQUAL"]!
          result.accepted = true
        } else {
          result.sound = InputReceived["INVALID"]!
        }
        
      } else {
        print("input not recognized: \(input)")
      }
    }
    
    if result.accepted == false {
      result.lastCalc = ""
    }
    result.currCalc = m_currCalc
    return result
  }
  
  
  private func CanInputOperator (blank_valid: Bool) -> Bool {
    
    if m_lastInputState == InputState.dot ||
       (!blank_valid && m_lastInputState == InputState.blank) {
      return false
    }
    
    if m_lastInputState == InputState.operation {
      
      if m_currCalc.count > 1 {
        EraseLastInput()
      } else {
        // if current calculation is starting with negative
        // op and user tries to digit another op, this last
        // operation is ignored
        return false
      }
    }
    
    if m_lastInputState == InputState.answer {
      return UseLastAnswer()
    }
    return true
    
  }
  
  
  private func Equal () -> Bool {
    
    let debug = false
    
    if m_lastInputState == InputState.blank  ||
       m_lastInputState == InputState.answer ||
       m_lastInputState == InputState.operation {
      return false
    }
    var numbers_array: [Double] = []
    var operators_array: [String] = []
    var number_str: String?
    var max_precision = -1
    var last_state = InputState.blank
    
    for (index, char) in m_currCalc.enumerated() {
      let char_str = String(char)
      
      if last_state == InputState.blank &&
         char_str == Operators["MINUS"] {
        
        number_str = Operators["MINUS"]
        continue
      }
      
      let recog_state = RecognizeState(input: char_str)
      var try_recog_number = false
      
      if recog_state == InputState.number ||
         recog_state == InputState.dot {
        
        last_state = recog_state
        number_str = (number_str ?? "") + char_str
        if index == m_currCalc.count-1 {
          try_recog_number = true
        }
        
      }
      else if recog_state == InputState.operation {
        operators_array.append(char_str)
        try_recog_number = true
      }
      
      if try_recog_number {
        
        let number_dbl = Double(number_str!)
        if number_dbl != nil {
          
          numbers_array.append(number_dbl!)
          var dot_index = 0
          
          for (index2, num_char) in number_str!.enumerated() {
            
            if num_char == "." {
              dot_index = index2
              break
            }
            
          }
          
          var total_precision = 0
          if dot_index > 0 {
            total_precision = (number_str!.count - 1) - dot_index
          }
          if debug {
            print("number_str \(number_str!)")
            print("total_precision \(total_precision)")
          }
          if max_precision < total_precision {
            max_precision = total_precision
          }
          number_str = nil
          last_state = InputState.blank
        }
      }
    }
    
    if debug {
      print("max_precision: \(max_precision)")
      print("numbers_array.count = \(numbers_array.count)")
      print(numbers_array)
      print("operators_array.count = \(operators_array.count)")
      print(operators_array)
      assert(operators_array.count < numbers_array.count)
    }
    var op_count = operators_array.count
    var index = 0
    if op_count > 0 {
      repeat
      {
        let operation = operators_array[index]
        if operation == Operators["DIV"] ||
           operation == Operators["MULT"] {
          
          operators_array.remove(at:index)
          op_count -= 1
          var num_1 = numbers_array.remove(at:index)
          let num_2 = numbers_array.remove(at:index)
          //print("priority: \(num_1) \(operation) \(num_2)")
          if operation == Operators["MULT"] {
            num_1 = num_1 * num_2
          } else if (operation == Operators["DIV"]) {
            num_1 = num_1 / num_2
          }
          //print("result: \(num_1)")
          numbers_array.insert(num_1, at: index)
        } else {
          index += 1
        }
      } while (index < op_count)
    }
    //print("numbers_array.count = \(numbers_array.count)")
    //print(numbers_array)
    //print("operators_array.count = \(operators_array.count)")
    //print(operators_array)
    
    var result = 0.0
    for (index, number) in numbers_array.enumerated() {
      if (index == 0) {
        result = number
        continue
      }
      let operation = operators_array[index-1]
      //print("calculating: \(result) \(operation) \(number)")
      if (operation == Operators["PLUS"]) {
        result = result + number
      }
      else if (operation == Operators["MINUS"]) {
        result = result - number
      }
      else if (operation == Operators["MULT"]) {
        result = result * number
      }
      else if (operation == Operators["DIV"]) {
        result = result / number
      }
      if debug {
        print("result: \(result)")
      }
    }
    
    let result_int = Int(exactly: result)
    if debug {
      print("result_int: \(result_int)")
    }
    if (result_int != nil) {
      m_lastAnswer = String(result_int!)
    }
    else {
      if debug {
        print("max_precision: \(max_precision)")
      }
      var format = "%.3f"
      if max_precision > 0 {
        format = "%." + String(max_precision) + "f"
      }
      if debug {
        print("format: \(format)")
      }
      m_lastAnswer = String(format:format , result)
    }
    m_currCalc = m_currCalc + "=" + m_lastAnswer!
    m_lastInputState = InputState.answer
    if (result.isInfinite || result.isNaN) {
      m_lastAnswer = nil
    }
    return true
  }
  
  private func EraseLastInput () {
    let index = m_currCalc.index(m_currCalc.endIndex, offsetBy: -1)
    m_currCalc = String(m_currCalc[..<index])
    if m_currCalc.isEmpty {
      m_currCalc = ""
    }
    m_lastInputState = RecognizeState(input: nil)
  }
  
  private func Clear () {
    m_currCalc = ""
    m_lastInputState = InputState.blank
  }
  
  private func UseLastAnswer () -> Bool {
    if m_lastAnswer == nil ||
       m_lastInputState == InputState.number ||
       m_lastInputState == InputState.dot    {
      return false
    }
    if m_lastInputState == InputState.answer {
      m_currCalc = ""
    }
    m_currCalc = m_currCalc + m_lastAnswer!
    m_lastInputState = InputState.number
    return true
  }
  
  private func RecognizeState (input:String?) -> InputState {
    var state = InputState.unknow
    var _input = input
    if _input == nil {
      if m_currCalc == "" {
        state = InputState.blank
      }
      else {
        let index = m_currCalc.index(m_currCalc.endIndex, offsetBy: -1)
        _input = String(m_currCalc[index])
      }
    }
    if state == InputState.unknow {
      assert(_input != nil)
      if _input == "0" || _input == "1" || _input == "2" || _input == "3" || _input == "4" ||
         _input == "5" || _input == "6" || _input == "7" || _input == "8" || _input == "9" {
        state = InputState.number
      }
      else if _input == Operators["PLUS"]  ||
              _input == Operators["MINUS"] ||
              _input == Operators["MULT"]  ||
              _input == Operators["DIV"]   {
        state = InputState.operation
      }
      else if _input == "." {
        state = InputState.dot
      }
      else if _input == "=" {
        state = InputState.equal
      }
      else {
        print("RecognizeState: \(_input ?? "(nil)")")
        state = InputState.error
      }
    }
    //print("RecognizeState() _input: \(_input ?? "(nil)") | state: \(state)")
    return state
  }
}
