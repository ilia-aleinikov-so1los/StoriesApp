//
//  StoryStateServiceProtocol.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation

protocol StoryStateServiceProtocol {
    func getStoryState(userId: Int, storyId: UUID) -> StoryState
    func updateStoryState(storyState: StoryState)
    func getAllStoryStates() -> [StoryState]
    func hasUnseenStories(userId: Int) -> Bool
}
