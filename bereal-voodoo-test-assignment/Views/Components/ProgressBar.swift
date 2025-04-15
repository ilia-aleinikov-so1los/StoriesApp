//
//  ProgressBar.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.white.opacity(0.3))
                    .cornerRadius(2)
                
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(2)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 2)
    }
}
