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
                .withHostingWindow { window in
                    #if targetEnvironment(macCatalyst)
                    if let titlebar = window?.windowScene?.titlebar {
                        titlebar.titleVisibility = .hidden
                        titlebar.toolbar = nil
                    }
                    #endif
                }
        }
        .commands {
            SidebarCommands()
        }
        // NOTE: this should be the way to do it, but the methods are not annotated
        //       for the environment so...
//        #if targetEnvironment(macCatalyst)
//        .windowStyle(.hiddenTitleBar)
//        .windowToolbarStyle(.unified(showsTitle: false))
//        #endif
    }
}
