//
//  Post.List.ViewModel.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine

extension Scene.Post.List {
    
    class ViewModel {
        
        private let coordinator: Coordinator.Post
        private let worker: Worker.Post
        
        private var page: Int = 1
        @Published var posts: [Model.Post] = []
        @Published var isLoading: Bool = false

        init(coordinator: Coordinator.Post, worker: Worker.Post = .init()) {
            self.coordinator = coordinator
            self.worker = worker
        }
        
        func goToPostDetail(index: Int) {
            guard let postId = posts[index].id else { return }
            coordinator.startDetails(postId: postId)
        }
        
        func goToCreatePost() {
            // TODO: Redirect to Create Post
        }
        
        func fetchPosts() {
            guard page > 0 else { return }
            isLoading.toggle()
            
            worker.getPostsByPage(page: page, success: { [weak self] posts in
                guard let self = self else { return }
                self.page = (posts.isEmpty) ? -1 : (self.page + 1)
                self.posts.append(contentsOf: posts)
                self.isLoading.toggle()
            }, failure: { [weak self] in
                guard let self = self else { return }
                self.isLoading.toggle()
                self.coordinator.showError { [weak self] _ in
                    guard let self = self else { return }
                    self.fetchPosts()
                } cancel: { _ in }
            })
        }
        
        func refreshData() {
            self.page = 1
            self.posts.removeAll()
            fetchPosts()
        }
    }
}
