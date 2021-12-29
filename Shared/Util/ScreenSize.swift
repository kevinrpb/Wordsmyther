//
//  ScreenSize.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

struct ScreenSize {
    #if os(watchOS)
    static var width: CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    #elseif os(iOS)
    static var width: CGFloat = UIScreen.main.bounds.size.width
    #elseif os(macOS)
    static var width: CGFloat = NSScreen.main?.visibleFrame.size.width ?? 1000
    #endif
}
