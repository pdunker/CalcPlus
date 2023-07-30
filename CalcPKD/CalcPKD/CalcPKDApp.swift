//
//  CalcPKDApp.swift
//  CalcPKD
//
//  Created by Philip Dunker on 12/07/23.
//

import SwiftUI

@main
struct CalcPKDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GlobalEnvironment())
        }
    }
}

//SwiftUI: How do I lock a particular View in Portrait mode whilst allowing others to change orientation?
//https://stackoverflow.com/questions/66037782/swiftui-how-do-i-lock-a-particular-view-in-portrait-mode-whilst-allowing-others
class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
