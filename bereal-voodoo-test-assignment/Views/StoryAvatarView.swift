//
//  StoryAvatarView.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import SwiftUI

struct StoryAvatarView: View {
    let user: User
    let hasUnseenStories: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(hasUnseenStories ? Color.blue : Color.gray, lineWidth: 2)
                    .frame(width: 70, height: 70)
                
                AsyncImage(url: URL(string: user.profilePictureURL)!) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 62, height: 62)
                }
                .frame(width: 62, height: 62)
                .clipShape(Circle())
            }
            
            Text(user.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
