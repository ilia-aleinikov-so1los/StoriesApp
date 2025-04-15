//
//  StoryState.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation

struct StoryState: Codable, Equatable {
    let userId: Int
    let storyId: UUID
    var seen: Bool
    var liked: Bool
    
    init(userId: Int, storyId: UUID, seen: Bool = false, liked: Bool = false) {
        self.userId = userId
        self.storyId = storyId
        self.seen = seen
        self.liked = liked
    }
}
