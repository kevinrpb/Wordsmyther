//
//  WordsView.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import SwiftUI

struct WordsView: View {
    @EnvironmentObject var controller: Controller

    var body: some View {
        VStack {
            Text("words")
        }
    }
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        WordsView()
    }
}
