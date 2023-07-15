//
//  ContentView.swift
//  CalcPKD
//
//  Created by Philip Dunker on 12/07/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        StoryBoardView().edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Using StoryBoard In SwiftUI How To Embed StoryBoard In SwiftUI How To Use StoryBoard In SwiftUI
//https://www.youtube.com/watch?v=T8_uqibv0YI
struct StoryBoardView: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Home")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
