//
//  StoriesListViewModel.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import Foundation
import Combine

class StoriesListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var hasError = false
    @Published var errorMessage = ""
    
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private let storyStateService: StoryStateServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         storyStateService: StoryStateServiceProtocol = StoryStateService()) {
        self.networkService = networkService
        self.storyStateService = storyStateService
        loadMoreUsersIfNeeded()
    }
    
    func loadMoreUsersIfNeeded() {
        guard !isLoading else { return }
        
        isLoading = true
        hasError = false
        
        networkService.fetchUsers(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.hasError = true
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] newUsers in
                guard let self = self else { return }
                self.users.append(contentsOf: newUsers)
                self.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func hasUnseenStories(for user: User) -> Bool {
        return storyStateService.hasUnseenStories(userId: user.id)
    }
    
    func storyStates(for user: User) -> [StoryState] {
        return storyStateService.getAllStoryStates().filter { $0.userId == user.id }
    }
}
