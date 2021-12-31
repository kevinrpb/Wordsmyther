//
//  WordsmytherApp.swift
//  Shared
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

@main
struct WordsmytherApp: App {
    static let tintColor: Color = .indigo

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            SidebarCommands()
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
