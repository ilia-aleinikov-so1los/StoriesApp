//
//  Story.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation

struct Story: Identifiable, Equatable {
    let id: UUID
    let userId: Int
    let imageURL: URL
    let timestamp: Date
    
    init(userId: Int, storyIndex: Int = 0) {
        self.id = UUID()
        self.userId = userId
        
        let imageId = (userId * 10) + storyIndex
        self.imageURL = URL(string: "https://picsum.photos/id/\(imageId % 1000)/800/1200")!
        self.timestamp = Date()
    }
    
    static func generateStories(for userId: Int, count: Int = 3) -> [Story] {
        var stories: [Story] = []
        for i in 0..<count {
            let story = Story(userId: userId, storyIndex: i)
            stories.append(story)
        }
        return stories
    }
}
