//
//  ContentView.swift
//  CalcPKD
//
//  Created by Philip Dunker on 12/07/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    @State private var darkMode = true
    
    @State private var textColor: Color = .white
    
    let buttons: [[CalcButton]] = [
        [.ac, .lastResult, .delete, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals],
        [.sound, .like]
    ]
    
    // Use ScrollViewReader in SwiftUI to scroll to a new item
    // https://nilcoalescing.com/blog/ScrollToNewlyAddedItemUsingScrollViewReaderAndOnChangeModifier/
    @Namespace var label_end_ID
    @Namespace var calc_end_ID
    
    @State private var copyAlert = false
    
    var body: some View {
        let screenSize = UIScreen.main.bounds
        
        ZStack (alignment: .bottom) {
            
            if (darkMode) {
                Color.black.edgesIgnoringSafeArea(.all)
            } else {
                Color.white.edgesIgnoringSafeArea(.all)
            }
            
            VStack() {

                // Historic
                ScrollViewReader { scrollProxyV in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack (alignment: .leading) {
                            ForEach(env.oldCalcs, id: \.self) { calc in
                                ScrollViewReader { _ in
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack {
                                            Text(calc)
                                                .lineLimit(1)
                                                .font(.system(size: 64))
                                                .foregroundColor(textColor)
                                                .frame(minWidth: screenSize.width, maxWidth: .infinity, alignment: .trailing)
                                                .onTapGesture {
                                                    UIPasteboard.general.string = calc
                                                    copyAlert = true
                                                }
                                                .alert(isPresented: $copyAlert) {
                                                    Alert(
                                                        title: Text("Copied to clipboard")
                                                    )
                                                }
                                        }
                                    }
                                }
                            }
                            Text("") // workaround to scroll to the last calculation
                                .id(calc_end_ID)
                                .foregroundColor(textColor)
                        }
                    }
                    .onChange(of: env.scrollToLast) { id in
                        withAnimation {
                            scrollProxyV.scrollTo(calc_end_ID, anchor: .bottom)
                        }
                    }
                }
                
                
                // Current Calculation
                ScrollViewReader { scrollProxyH in
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            Text(env.display)
                                .lineLimit(1)
                                .font(.system(size: 64))
                                .foregroundColor(textColor)
                                .frame(minWidth: screenSize.width, maxWidth: .infinity, alignment: .trailing)
                                .onTapGesture {
                                    UIPasteboard.general.string = env.display
                                    copyAlert = true
                                }
                                .alert(isPresented: $copyAlert) {
                                    Alert(
                                        title: Text("Copied to clipboard")
                                    )
                                }
                            Text("") // workaround to make the last digit appear in screen after typed
                                .id(label_end_ID)
                        }
                    }
                    .onChange(of: env.scrollToLast) { id in
                        withAnimation {
                            scrollProxyH.scrollTo(label_end_ID, anchor: .leading)
                        }
                    }
                }
                
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalcButtonView(button: button)
                        }
                    }
                }

            }
            
        }
        
    }

}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView().environmentObject(GlobalEnvironment())
    }
}

// Using StoryBoard In SwiftUI How To Embed StoryBoard In SwiftUI How To Use StoryBoard In SwiftUI
// https://www.youtube.com/watch?v=T8_uqibv0YI
struct StoryBoardView: UIViewControllerRepresentable
{
    func makeUIViewController(context: Context) -> some UIViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context)
    {
    }
}
