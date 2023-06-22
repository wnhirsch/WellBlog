//
//  Post.Details.ViewModel.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine

extension Scene.Post.Details {
    
    class ViewModel {
        
        private let postId: Int
        private let coordinator: Coordinator.Post
        private let worker: Worker.Post
        
        @Published var post = Model.Post()
        @Published var isLoading: Bool = false

        init(postId: Int, coordinator: Coordinator.Post, worker: Worker.Post = .init()) {
            self.postId = postId
            self.coordinator = coordinator
            self.worker = worker
        }
        
        func fetchPost() {
            isLoading.toggle()
            
            worker.getPost(id: postId, success: { [weak self] post in
                guard let self = self else { return }
                self.post = post
                self.isLoading.toggle()
            }, failure: { [weak self] in
                guard let self = self else { return }
                self.isLoading.toggle()
                self.coordinator.showError { [weak self] _ in
                    guard let self = self else { return }
                    self.fetchPost()
                } cancel: { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator.dismiss()
                }
            })
        }
        
        func deletePost() {
            isLoading.toggle()
            
            worker.deletePost(id: postId, success: { [weak self] in
                guard let self = self else { return }
                self.isLoading.toggle()
                self.coordinator.dismiss()
            }, failure: { [weak self] in
                guard let self = self else { return }
                self.isLoading.toggle()
                self.coordinator.showError { [weak self] _ in
                    guard let self = self else { return }
                    self.deletePost()
                } cancel: { _ in }
            })
        }
    }
}
