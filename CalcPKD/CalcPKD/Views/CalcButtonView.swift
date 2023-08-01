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
    
    var state: Bool
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        
        Button(action: {
            self.env.Input(button: self.button)
        }) {
            if button.image.isEmpty == false {
                ZStack {
                    Image(systemName: button.image)
                        .font(.system(size: 24))
                        .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
                        .foregroundColor(.white)
                        .background(button.backgroundColor)
                        .cornerRadius(self.buttonWidth(button: button))
                    if state == false {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 35, height: 35)
                            .mask(
                                Image(systemName: "nosign")
                                    .font(.system(size: 34)))
                    }
                }
            }
            else {
                Text(button.title)
                    .font(.system(size: 32))
                    .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
                    .foregroundColor(.white)
                    .background(button.backgroundColor)
                    .cornerRadius(self.buttonWidth(button: button))
            }
        }
    }
    
    private func buttonWidth(button: CalcButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - 4 * 12) / 4 * 2
        }
        if button.isSmall {
            return (UIScreen.main.bounds.width - 5 * 12) / 8
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    private func buttonHeight(button: CalcButton) -> CGFloat {
        if button.isSmall {
            return (UIScreen.main.bounds.width - 5 * 12) / 8
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }

}

struct CalcButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CalcButtonView(button: .delete, state: true)
    }
}
