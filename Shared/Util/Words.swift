//
//  Words.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import Foundation

struct Words {
    static let allowedLetters: [Character] = Array("QWERTYUIOPASDFGHJKLZXCVBNM")
    
    static let allowedWords: [Int: [String]] = [
        3: Self.readWordArray(of: 3),
        4: Self.readWordArray(of: 4),
        5: Self.readWordArray(of: 5),
        6: Self.readWordArray(of: 6),
        7: Self.readWordArray(of: 7),
        8: Self.readWordArray(of: 8),
        9: Self.readWordArray(of: 9)
    ]
    
    static private let decoder: JSONDecoder = .init()
    
    private static func readWordArray(of length: Int) -> [String] {
        guard let path = Bundle.main.path(forResource: "words\(length)", ofType: "json") else {
            return []
        }

        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let words = try Self.decoder.decode([String].self, from: data)
            
            return words
        } catch {
            return []
        }
    }
}
