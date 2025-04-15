//
//  StoriesListView.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import SwiftUI

struct StoriesListView: View {
    @StateObject private var viewModel = StoriesListViewModel()
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(viewModel.users) { user in
                            StoryAvatarView(user: user, hasUnseenStories: viewModel.hasUnseenStories(for: user))
                                .onTapGesture {
                                    selectedUser = user
                                }
                                .onAppear {
                                    if user == viewModel.users.last {
                                        viewModel.loadMoreUsersIfNeeded()
                                    }
                                }
                        }
                        
                        if viewModel.isLoading {
                            LoadingView()
                        }
                    }
                    .padding()
                }
                .frame(height: 100)
                
                Spacer()
                
                if viewModel.hasError {
                    ErrorView(message: viewModel.errorMessage) {
                        viewModel.loadMoreUsersIfNeeded()
                    }
                }
            }
            .navigationTitle("Stories")
            .fullScreenCover(item: $selectedUser) { user in
                StoryView(viewModel: StoryViewModel(user: user))
                    .onDisappear {
                        selectedUser = nil
                    }
            }
        }
    }
}
