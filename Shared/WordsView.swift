//
//  WordsView.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

struct WordsView: View {
    @EnvironmentObject var controller: Controller
    
    let length: Int

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack {
                    LazyVGrid(columns: Array(repeating: .init(), count: 2)) {
                        ForEach(controller.words[length] ?? [], id: \.self) { word in
                            HStack {
                                Spacer()
                                Text(word)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.regularMaterial)
                            )
                        }
                    }
                    .padding()
                    
                }
                Spacer()
            }
        }
        .background(Color.indigo.opacity(0.2))
        .navigationTitle("\(length) letters")
    }
}
