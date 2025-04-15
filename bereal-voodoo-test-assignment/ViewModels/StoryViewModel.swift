//
//  StoryViewModel.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation
import Combine

class StoryViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var stories: [Story] = []
    @Published var currentStoryIndex = 0
    @Published var storyStates: [StoryState] = []
    
    private let storyStateService: StoryStateServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var currentStory: Story? {
        guard !stories.isEmpty, currentStoryIndex < stories.count else { return nil }
        return stories[currentStoryIndex]
    }
    
    var hasNext: Bool {
        return currentStoryIndex < stories.count - 1
    }
    
    var hasPrevious: Bool {
        return currentStoryIndex > 0
    }
    
    var progressPercentage: Double {
        guard !stories.isEmpty else { return 0 }
        return Double(currentStoryIndex + 1) / Double(stories.count)
    }
    
    init(user: User, storyStateService: StoryStateServiceProtocol = StoryStateService()) {
        self.currentUser = user
        self.storyStateService = storyStateService
        
        self.stories = Story.generateStories(for: user.id)
        loadStoryStates()
    }
    
    func loadStoryStates() {
        storyStates = storyStateService.getAllStoryStates().filter { storyState in
            self.stories.contains { $0.userId == storyState.userId && $0.id == storyState.storyId }
        }
    }
    
    func markCurrentStoryAsSeen() {
        guard let currentStory = currentStory else { return }
        
        var storyState = storyStateService.getStoryState(userId: currentUser.id, storyId: currentStory.id)
        storyState.seen = true
        storyStateService.updateStoryState(storyState: storyState)
        
        loadStoryStates()
    }
    
    func toggleLike() {
        guard let currentStory = currentStory else { return }
        
        var storyState = storyStateService.getStoryState(userId: currentUser.id, storyId: currentStory.id)
        storyState.liked.toggle()
        storyStateService.updateStoryState(storyState: storyState)
        
        loadStoryStates()
    }
    
    func isCurrentStoryLiked() -> Bool {
        guard let currentStory = currentStory else { return false }
        let storyState = storyStateService.getStoryState(userId: currentUser.id, storyId: currentStory.id)
        return storyState.liked
    }
    
    func nextStory() {
        if hasNext {
            currentStoryIndex += 1
            markCurrentStoryAsSeen()
        }
    }
    
    func previousStory() {
        if hasPrevious {
            currentStoryIndex -= 1
        }
    }
}
