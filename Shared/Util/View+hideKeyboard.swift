//
//  View+hideKeyboard.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

#if os(iOS)
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
#endif
