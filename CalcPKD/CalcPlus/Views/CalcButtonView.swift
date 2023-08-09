//
//  CalcButtonView.swift
//  MyCalculator
//
//  Created by Philip Dunker on 12/03/23.
//  Copyright © 2023 Lets Build That App. All rights reserved.
//

import SwiftUI

struct CalcButtonView: View {
  
  var button: CalcButton
  var soundOn: Bool
  var darkMode: Bool
  var elemSizes: ElementsSizes
  
  @EnvironmentObject var env: GlobalEnvironment
  
  var body: some View {
    if button.type == "menu" {
      Menu {
        ForEach (button.options, id: \.self) { str in
          Button(action: {
            env.SetFontSize(option: str)
          }) {
            Label(str, systemImage: button.image)
          }
        }
      } label: {
        Image(systemName: button.image)
          .font(.system(size: elemSizes.funcBtnImageSize))
          .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
          .foregroundColor(.white)
          .background(button.backgroundColor)
          .cornerRadius(self.buttonWidth(button: button))
      } /*primaryAction: {
         addBookmark()
         }*/
    } else {
      Button(action: {
        self.env.Input(button: self.button)
      }) {
        if button.image.isEmpty == false {
          let image: String = (button.type == "state" && darkMode) ? button.image2 : button.image
          ZStack {
            Image(systemName: image)
              .font(.system(size: elemSizes.funcBtnImageSize))
              .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
              .foregroundColor(.white)
              .background(button.backgroundColor)
              .cornerRadius(self.buttonWidth(button: button))
            if button == .sound && soundOn == false {
              let extra_size: CGFloat = 10
              Rectangle()
                .fill(.white)
                .frame(width: elemSizes.funcBtnImageSize+extra_size, height: elemSizes.funcBtnImageSize+extra_size)
                .mask(
                  Image(systemName: "nosign")
                    .font(.system(size: elemSizes.funcBtnImageSize+extra_size)))
            }
          }
        }
        else {
          Text(button.title)
            .font(.system(size: elemSizes.btnsTextSize))
            .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
            .foregroundColor(.white)
            .background(button.backgroundColor)
            .cornerRadius(self.buttonWidth(button: button))
        }
      }
    }
  }
  
  let normal_btn_size = (UIScreen.main.bounds.width/4) - (4*3)
  let func_btn_size = (UIScreen.main.bounds.width/5) - (5*5)
  
  private func buttonWidth(button: CalcButton) -> CGFloat {
    if button == .zero {
      return 2*normal_btn_size*elemSizes.sizeRatio
    }
    if button.isSmall {
      return func_btn_size*elemSizes.sizeRatio
    }
    return normal_btn_size*elemSizes.sizeRatio
  }
  
  private func buttonHeight(button: CalcButton) -> CGFloat {
    if button.isSmall {
      return func_btn_size*elemSizes.sizeRatio
    }
    return normal_btn_size*elemSizes.sizeRatio
  }
  
} // struct CalcButtonView: View

struct CalcButtonView_Previews: PreviewProvider {
  
  static var previews: some View {
    let buttons: [[CalcButton]] = [
      [.ac, .lastResult, .delete, .divide],
      [.seven, .eight, .nine, .multiply],
      [.four, .five, .six, .minus],
      [.one, .two, .three, .plus],
      [.zero, .decimal, .equals],
      [.eraser, .sound, .txt_size, .theme, .like]
    ]
    
    VStack {
      ForEach(buttons, id: \.self) { row in
        HStack (spacing: 12) {
          let elemSizes: ElementsSizes = ElementsSizes(btnsTextSize: 34, dispTextSize: 44, funcBtnImageSize: 24, sizeRatio: 0.9)
          ForEach(row, id: \.self) { button in
            CalcButtonView(button: button, soundOn: false, darkMode: false, elemSizes: elemSizes)
          }
        }
      }
    }
  }
}
