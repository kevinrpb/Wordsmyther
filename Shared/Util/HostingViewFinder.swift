//
//  HostingViewFinder.swift
//  Wordsmyther (iOS)
//
//  Created by Kevin Romero Peces-Barba on 31/12/21.
//

import SwiftUI

struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
