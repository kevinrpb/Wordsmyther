//
//  Controller.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import Algorithms
import SwiftUI

@MainActor
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
    
    private var generationTask: Task<(), Never>? = nil
    private var lastGenerated: [Character] = []
    
    // MARK: array managing
    
    private func select(_ letter: Character) {
        guard Words.allowedLetters.contains(letter) else { return }

        // TODO: Should actually allow duplicates
        if selectedLetters.contains(letter) {
            return deselect(letter)
        }

        guard selectedLetters.count < 9 else { return }
        
        selectedLetters.append(letter)
        hasChanges = true
    }
    
    private func deselect(_ letter: Character) {
        guard selectedLetters.contains(letter) else { return }

        selectedLetters.removeAll(where: { $0 == letter })
        hasChanges = true
    }
    
    private func clearSelected() {
        guard selectedLetters.count > 0 else { return }

        selectedLetters.removeAll()
        hasChanges = true
    }
    
    // MARK: Word generation
    
    private func generateWords() {
        isLoading = true
        
        generationTask = Task(priority: .background) {
            let globalStart = DispatchTime.now()

            for length in words.keys {
                guard let task = generationTask, !task.isCancelled else { return }
                
                let start = DispatchTime.now()

                words[length] = await Words.shared.generateWords(of: length, using: selectedLetters)
                
                let end = DispatchTime.now()
                let ellapsed = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                let timeInterval = Double(ellapsed) / 1_000_000_000 // Technically could overflow for long running tests
                
                print("[!] [L=\(length)] Generated \(words[length]!.count) words in \(timeInterval) seconds")
            }

            lastGenerated = selectedLetters
            hasChanges = false
            isLoading = false

            let globalEnd = DispatchTime.now()
            let globalEllapsed = globalEnd.uptimeNanoseconds - globalStart.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let globalTimeInterval = Double(globalEllapsed) / 1_000_000_000 // Technically could overflow for long running tests
            
            let generatedWords = words.keys.reduce(into: 0) { $0 += words[$1]!.count }
            
            print("[!] [***] Generated \(generatedWords) words in \(globalTimeInterval) seconds")
        }
    }
    
    // MARK: UI handlers
    
    func gridTapped(at index: Int) {
        guard selectedLetters.indices.contains(index) else { return }
        selectedLetters.remove(at: index)
    }
    
    func inputUpdated(_ newValue: String) {
        guard newValue != String(selectedLetters) else { return }
        hasChanges = true

        if newValue.count > selectedLetters.count {
            // We added a letter
            guard selectedLetters.count < 9,
                  let letter = newValue.uppercased().last,
                  Words.allowedLetters.contains(letter) else { return }

            selectedLetters.append(letter)
            
            if selectedLetters.count == 9 && selectedLetters == lastGenerated {
                hasChanges = false
            }
        } else {
            // We removed a letter (backspace)
            selectedLetters.removeLast()
        }
    }
    
    func inputSubmitted() {
        guard selectedLetters.count == 9 else { return }
        generateWords()
    }
    
    func eraseButtonTapped() {
        if isLoading {
            // TODO: This doesn't really do what I want since it waits to complete next generation
            generationTask?.cancel()
        } else {
            clearSelected()
        }
    }
    
    func generateButtonTapped() {
        guard selectedLetters.count == 9 else { return }
        generateWords()
    }
}
