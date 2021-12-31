//
//  Words.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import Foundation

actor Words {
    static let allowedLetters: [Character] = Array("QWERTYUIOPASDFGHJKLZXCVBNM")
    
    private lazy var allowedWords: [Int: Set<String>] = { [
        3: Set(readWordArray(of: 3)),
        4: Set(readWordArray(of: 4)),
        5: Set(readWordArray(of: 5)),
        6: Set(readWordArray(of: 6)),
        7: Set(readWordArray(of: 7)),
        8: Set(readWordArray(of: 8)),
        9: Set(readWordArray(of: 9))
    ] }()
    
    private let decoder: JSONDecoder = .init()
    
    public static let shared: Words = .init()
    private init() {}

    func generateWords(of length: Int, using characters: [Character]) -> [String] {
        guard (3...9).contains(length) else { return [] }
        
        let allowed = allowedWords[length]!
        
        let permutations = characters
            .uniquePermutations(ofCount: length)
            .map { String($0) }
            .asSet()
            
            // If the file was loaded correctly, us is to filter, otherwise allow all
//            .filter { allowed.count > 0 ? allowed.contains($0.lowercased()) : true }
        
        let validWords = allowed.count > 0
            ? allowed.intersection(permutations)
            : permutations
        
        return Array(validWords)
    }
    
    private func readWordArray(of length: Int) -> [String] {
        guard let path = Bundle.main.path(forResource: "words\(length)", ofType: "json", inDirectory: "words") else {
            return []
        }

        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let words = try decoder.decode([String].self, from: data)
            
            return words.map { $0.uppercased() }
        } catch {
            return []
        }
    }
}
