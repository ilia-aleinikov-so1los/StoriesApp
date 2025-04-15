//
//  TapAreaView.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import SwiftUI

struct TapAreaView: UIViewRepresentable {
    var tappedCallback: (CGPoint) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        view.addGestureRecognizer(tap)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(callback: tappedCallback)
    }

    class Coordinator: NSObject {
        var callback: (CGPoint) -> Void

        init(callback: @escaping (CGPoint) -> Void) {
            self.callback = callback
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            callback(location)
        }
    }
}
