//
//  StoryStateService.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation
import Combine

class StoryStateService: StoryStateServiceProtocol {
    private let storyStatesKey = "storyStates"
    private var storyStates: [StoryState] = []
    
    init() {
        loadStoryStates()
    }
    
    func getStoryState(userId: Int, storyId: UUID) -> StoryState {
        if let existingState = storyStates.first(where: { $0.userId == userId && $0.storyId == storyId }) {
            return existingState
        }
        
        let newState = StoryState(userId: userId, storyId: storyId)
        storyStates.append(newState)
        saveStoryStates()
        return newState
    }
    
    func updateStoryState(storyState: StoryState) {
        if let index = storyStates.firstIndex(where: { $0.userId == storyState.userId && $0.storyId == storyState.storyId }) {
            storyStates[index] = storyState
        } else {
            storyStates.append(storyState)
        }
        saveStoryStates()
    }
    
    func getAllStoryStates() -> [StoryState] {
        return storyStates
    }
    
    func hasUnseenStories(userId: Int) -> Bool {
        let userStoryStates = storyStates.filter { $0.userId == userId }
        
        if userStoryStates.isEmpty {
            return true
        }
        
        return userStoryStates.contains { !$0.seen }
    }
    
    private func loadStoryStates() {
        if let data = UserDefaults.standard.data(forKey: storyStatesKey) {
            do {
                storyStates = try JSONDecoder().decode([StoryState].self, from: data)
            } catch {
                print("Error loading story states: \(error)")
                storyStates = []
            }
        }
    }
    
    private func saveStoryStates() {
        do {
            let data = try JSONEncoder().encode(storyStates)
            UserDefaults.standard.set(data, forKey: storyStatesKey)
        } catch {
            print("Error saving story states: \(error)")
        }
    }
}
