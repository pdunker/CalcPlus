//
//  CalcPKDApp.swift
//  CalcPKD
//
//  Created by Philip Dunker on 12/07/23.
//

import SwiftUI

@main
struct CalcPKDApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GlobalEnvironment())
        }
    }
}
