//
//  Post.Create.ViewModel.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine

extension Scene.Post.Create {
    
    class ViewModel {
        
        private let coordinator: Coordinator.Post
        private let worker: Worker.Post
        
        @Published var title: String = ""
        @Published var description: String = ""
        @Published var isLoading: Bool = false

        init(coordinator: Coordinator.Post, worker: Worker.Post = .init()) {
            self.coordinator = coordinator
            self.worker = worker
        }
        
        func createPost() {
            guard isTitleValid() && isDescriptionValid() else { return }
            isLoading.toggle()
            
            let newPost = Model.NewPost(title: title, description: description)
            worker.createPost(post: newPost, success: { [weak self] in
                guard let self = self else { return }
                self.coordinator.dismiss()
                self.isLoading.toggle()
            }, failure: { [weak self] in
                guard let self = self else { return }
                self.isLoading.toggle()
                self.coordinator.showError { [weak self] _ in
                    guard let self = self else { return }
                    self.createPost()
                } cancel: { _ in }
            })
        }
        
        func isTitleValid() -> Bool {
            return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        func isDescriptionValid() -> Bool {
            return !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}
