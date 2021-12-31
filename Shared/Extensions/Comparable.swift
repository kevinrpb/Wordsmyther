//
//  Comparable.swift
//  Wordsmyther
//
//  Created by Kevin Romero Peces-Barba on 29/12/21.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
    
    func clamped(between lowerBound: Self, and upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
}
