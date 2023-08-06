//
//  CalculatorButton.swift
//  CalculatorSwiftUILBTA
//
//  Created by Philip Dunker on 30/01/23.
//  Copyright © 2023 Lets Build That App. All rights reserved.
//

import SwiftUI

enum CalcButton: String {
  
  case zero, one, two, three, four, five, six, seven, eight, nine
  case equals, plus, minus, multiply, divide
  case decimal
  case ac, lastResult, delete
  case sound, like, eraser, txt_size, theme
  
  var title: String {
    
    switch self {
    case .zero: return "0"
    case .one: return "1"
    case .two: return "2"
    case .three: return "3"
    case .four: return "4"
    case .five: return "5"
    case .six: return "6"
    case .seven: return "7"
    case .eight: return "8"
    case .nine: return "9"
      
    case .plus: return "+"
    case .minus: return "-"
    case .multiply: return "×"
    case .divide: return "÷"
      
    case .equals: return "="
    case .decimal: return "."
      
    case .delete: return "Del"
    case .lastResult: return "LR"
    case .ac: return "AC"
      
      //case .sound: return "sound"
      //case .like: return "hand.thumbsup"
      //case .eraser: return "clock.badge.xmark"
      
    default:
      return rawValue
    }
  }
  
  var image: String {
    switch self {
    case .delete: return "eraser.line.dashed"
    case .sound: return "music.note"
    case .like: return "hand.thumbsup"
    case .eraser: return "clock.badge.xmark"
    case .txt_size: return "textformat.size"
    case .theme: return "sun.max.circle.fill"
    default:
      return ""
    }
  }
  
  var image2: String {
    switch self {
    case .theme: return "sun.max.circle"
    default:
      return ""
    }
  }
  
  var isSmall: Bool {
    switch self {
    case .sound, .like, .eraser, .txt_size, .theme:
      return true
    default:
      return false
    }
  }
  
  var type: String {
    switch self {
    case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
      return "number"
    case .plus, .minus, .multiply, .divide:
      return "operator"
    case .ac, .lastResult, .delete, .sound, .like, .eraser:
      return "function"
    case .txt_size:
      return "menu"
    case .theme:
      return "state"
    default:
      return self.rawValue
    }
  }
  
  var options: [String] {
    switch self {
    case .txt_size:
      return ["Small", "Medium", "Big"]
    default:
      return [""]
    }
  }
  
  var backgroundColor: Color {
    switch self {
    case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
      return Color(.darkGray)
    case .ac, .lastResult, .delete, .sound, .like, .eraser, .txt_size, .theme:
      return Color(.lightGray)
    default:
      return .orange
    }
  }
  
}
