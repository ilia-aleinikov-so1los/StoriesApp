//
//  LoadingView.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            Text("Loading...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 80, height: 80)
    }
}
