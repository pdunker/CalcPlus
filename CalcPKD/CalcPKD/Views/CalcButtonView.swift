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
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        
        Button(action: {
            self.env.Input(button: self.button)
        }) {
            if self.useImage(button: button) {
                Image(systemName: button.title)
                    .font(.system(size: 24))
                    .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
                    .foregroundColor(.white)
                    .background(button.backgroundColor)
                    .cornerRadius(self.buttonWidth(button: button))
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
        if button == .sound || button == .like {
            return (UIScreen.main.bounds.width - 5 * 12) / 8
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    private func buttonHeight(button: CalcButton) -> CGFloat {
        if button == .sound || button == .like {
            return (UIScreen.main.bounds.width - 5 * 12) / 8
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    private func useImage(button: CalcButton) -> Bool {
        if button == .sound || button == .like {
            return true
        }
        return false
    }
}

struct CalcButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CalcButtonView(button: .sound)
    }
}
