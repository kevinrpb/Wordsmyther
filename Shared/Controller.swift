//
//  Controller.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import Algorithms
import SwiftUI

class Controller: ObservableObject {
    @Published var selectedLetters: [Character] = []
    @Published var hasChanges: Bool = true
    @Published var isLoading: Bool = false
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
        guard Words.allowedLetters.contains(letter) else { return }

        // TODO: Should actually allow duplicates
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
        
        let permutations = selectedLetters
            .uniquePermutations(ofCount: length)
            .map { String($0) }
        
        DispatchQueue.main.sync {
            words[length] = permutations
        }
    }
    
    func generateWords() {
        isLoading = true
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now().advanced(by: .milliseconds(100))) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.words.keys.forEach { length in strongSelf.generateWords(of: length) }
            
            DispatchQueue.main.sync {
                strongSelf.hasChanges = false
                strongSelf.isLoading = false
            }
        }
    }
}
