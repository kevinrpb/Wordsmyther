//
//  WordsView.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

struct WordsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSize
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var controller: Controller
    
    let length: Int

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack {
                    LazyVGrid(columns: Array(repeating: .init(), count: horizontalSize == .compact ? 2 : 3)) {
                        ForEach(controller.words[length] ?? [], id: \.self) { word in
                            HStack {
                                Spacer()
                                Text(word)
                                    .foregroundColor(WordsmytherApp.tintColor)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(WordsmytherApp.bgStyle, strokeBorder: WordsmytherApp.tintColor.opacity(0.2))
                            )
                        }
                    }
                    .padding()
                    
                }
                Spacer()
            }
        }
        #if targetEnvironment(macCatalyst)
        .background(WordsmytherApp.tintColor.opacity(0.1))
        #else
        .background(WordsmytherApp.tintColor.opacity(0.2))
        #endif
        .navigationTitle("\(length) letters")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(controller.$isLoading) { _ in
            // TODO: This doesn't really work xD
            presentationMode.wrappedValue.dismiss()
        }
    }
}
