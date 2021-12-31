//
//  Icon.swift
//  Wordsmyther (iOS)
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import SwiftUI
import SwiftUIcon

struct Icon: View {
    private let offset: Double = 55
    private let indigo: Color = .init(
        hue: 240/360,
        saturation: 60/100,
        brightness: 60/100
    )
    private let color: Color = .init(
        hue: 240/360,
        saturation: 60/100,
        brightness: 90/100
    )

    var body: some View {
        IconStack { canvas in
            color
            
            Text("W")
                .font(.system(size: 500 * canvas.scale, weight: .bold))
                .scaleEffect(x: 1, y: 0.5, anchor: .top)
                .offset(y: canvas[offset])
                .foregroundColor(.white)

            Text("W")
                .font(.system(size: 500 * canvas.scale, weight: .bold))
                .rotationEffect(.degrees(180))
                .scaleEffect(x: 1, y: 0.5, anchor: .bottom)
                .offset(y: canvas[-1 * offset])
                .foregroundColor(.black)
        }
    }
}

#if DEBUG
struct Icon_Previews : PreviewProvider {
    static var previews: some View {
        IconPreviews(icon: Icon())
    }
}
#endif
