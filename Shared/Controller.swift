//
//  Controller.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import Foundation
import SwiftUI

class Controller: ObservableObject {
    static let allowedLetters: [Character] = Array("QWERTYUIOPASDFGHJKLZXCVBNM")
    
    @Published var selectedLetters: [Character] = []
    @Published var hasChanges: Bool = false
    @Published var words: [Int: [String]] = [
        3: [],
        4: [],
        5: [],
        6: [],
        7: [],
        8: [],
        9: []
    ]
    
    func select(_ letter: Character) {
        guard Self.allowedLetters.contains(letter) else { return }

        if selectedLetters.contains(letter) {
            return deselect(letter)
        }

        guard selectedLetters.count < 9 else { return }
        
        selectedLetters.append(letter)
        hasChanges = true
    }
    
    func deselect(_ letter: Character) {
        guard selectedLetters.contains(letter) else { return }

        selectedLetters.removeAll(where: { $0 == letter })
        hasChanges = true
    }
    
    func clearSelected() {
        guard selectedLetters.count > 0 else { return }

        selectedLetters.removeAll()
        hasChanges = true
    }
    
    private func generateWords(of length: Int) {
        guard (3...9).contains(length) else { return }
    }
    
    func generateWords() {
        words.keys.forEach { length in generateWords(of: length) }
    }
}
