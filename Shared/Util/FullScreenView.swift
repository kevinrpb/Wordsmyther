//
//  FullScreenView.swift
//  Wordsmyther (iOS)
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import SwiftUI

struct FullScreenView<Content: View>: View {
    @ViewBuilder
    let content: () -> Content

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                content()
                Spacer()
            }
            Spacer()
        }
    }
}
