//
//  StoryView.swift
//  bereal-voodoo-test-assignment
//
//  Created by evilGen on 15-04-2025.
//

import SwiftUI

struct StoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: StoryViewModel
    
    @State private var timer: Timer?
    @State private var progress: CGFloat = 0
    @State private var showLikeAnimation = false
    @State private var isImageLoading = true
    
    @GestureState private var translation: CGFloat = 0
    let storyDuration: TimeInterval = 5.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if let story = viewModel.currentStory {
                    SwiftUI.AsyncImage(url: story.imageURL) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .edgesIgnoringSafeArea(.all)
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(Image(systemName: "exclamationmark.triangle").foregroundColor(.white))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .id(story.imageURL)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        isImageLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isImageLoading = false
                        }
                    }
                    
                    if showLikeAnimation {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.red)
                            .opacity(showLikeAnimation ? 1 : 0)
                            .scaleEffect(showLikeAnimation ? 1.2 : 0.5)
                            .animation(.spring(), value: showLikeAnimation)
                    }
                    
                    VStack {
                        // Progress bar
                        HStack(spacing: 4) {
                            ForEach(0..<viewModel.stories.count, id: \.self) { index in
                                ProgressBar(
                                    progress: index < viewModel.currentStoryIndex ? 1 : (index == viewModel.currentStoryIndex ? progress : 0)
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // User info header
                        HStack {
                            AsyncImage(url: URL(string: viewModel.currentUser.profilePictureURL)!) {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            
                            Text(viewModel.currentUser.name)
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Spacer()
                            
                            Button {
                                stopTimer()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(8)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Footer actions
                        HStack {
                            Spacer()
                            
                            Button {
                                viewModel.toggleLike()
                                
                                if viewModel.isCurrentStoryLiked() {
                                    showLikeAnimation = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        showLikeAnimation = false
                                    }
                                }
                            } label: {
                                Image(systemName: viewModel.isCurrentStoryLiked() ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isCurrentStoryLiked() ? .red : .white)
                                    .font(.system(size: 24))
                                    .padding()
                            }
                        }
                        .padding(.bottom, 32)
                    }
                } else {
                    VStack {
                        Text("No stories available")
                            .foregroundColor(.white)
                            .font(.title)
                        
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    }
                }
                
//                TapAreaView { location in
//                    let screenWidth = UIScreen.main.bounds.width
//
//                    if location.x < screenWidth * 0.3 {
//                        viewModel.previousStory()
//                        resetTimer()
//                    } else if location.x > screenWidth * 0.7 {
//                        if viewModel.hasNext {
//                            viewModel.nextStory()
//                            resetTimer()
//                        } else {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    } else {
//                        // -
//                    }
//                }
            }
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        guard viewModel.currentStory != nil else { return }

                        let threshold: CGFloat = 50

                        if value.translation.width > threshold {
                            viewModel.previousStory()
                            resetTimer()
                        } else if value.translation.width < -threshold {
                            if viewModel.hasNext {
                                viewModel.nextStory()
                                resetTimer()
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
            )
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        viewModel.toggleLike()
                        if viewModel.isCurrentStoryLiked() {
                            showLikeAnimation = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                showLikeAnimation = false
                            }
                        }
                    }
            )
//            .highPriorityGesture(
//                TapGesture(count: 1)
//                    .onEnded { value in
//                        guard viewModel.currentStory != nil else {
//                            presentationMode.wrappedValue.dismiss()
//                            return
//                        }
//
//                        let width = UIScreen.main.bounds.width
//                        let tap = value.location.x
//
//                        if tap < width * 0.3 {
//                            viewModel.previousStory()
//                            resetTimer()
//                        } else if tap > width * 0.7 {
//                            if viewModel.hasNext {
//                                viewModel.nextStory()
//                                resetTimer()
//                            } else {
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                        }
//                    }
//            )
        }
        .onAppear {
            if viewModel.currentStory != nil {
                viewModel.markCurrentStoryAsSeen()
                startTimer()
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        progress = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            progress += 0.01 / storyDuration
            
            if progress >= 1.0 {
                if viewModel.hasNext {
                    viewModel.nextStory()
                    resetTimer()
                } else {
                    stopTimer()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func resetTimer() {
        stopTimer()
        startTimer()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
