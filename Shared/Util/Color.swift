//
//  Color.swift
//  Wordsmyther (iOS)
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import SwiftUI

extension Color {
    func lighter(by percentage: CGFloat = 30.0) -> Color? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color? {
        guard let adjusted = UIColor(self).adjust(by: percentage) else { return nil }
        
        return Color(uiColor: adjusted)
    }
    
    static let iconBG: Color = .indigo.lighter()!
}
