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
                    Text("words of length \(length)")
                }
                Spacer()
            }
        }
        .background(Color.indigo.opacity(0.2))
        .navigationTitle("\(length) letters")
    }
}
