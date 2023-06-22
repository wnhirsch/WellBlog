//
//  Post.Details.ViewController.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine
import UIKit

extension Scene.Post.Details {

    class ViewController: UIViewController, Loadable {

        private let contentView: View
        private let viewModel: ViewModel
        
        private var cancellables = Set<AnyCancellable>()

        init(viewModel: ViewModel) {
            contentView = View()
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            view = contentView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "details.title".localized(context: .post)
            bind()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        private func bind() {
            // Loading event
            viewModel.$isLoading.sink { [weak self] isLoading in
                guard let self = self else { return }
                self.contentView.deletePostButton.isEnabled = !isLoading
                isLoading ? self.showLoading() : self.hideLoading()
            }.store(in: &cancellables)
            
            // Load Posts Event
            viewModel.$post.sink { [weak self] post in
                guard let self = self else { return }
                self.contentView.setup(model: post)
            }.store(in: &cancellables)
            
            // New Post Button click Event
            contentView.deletePostPublisher.sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.deletePost()
            }.store(in: &cancellables)
            
            // First API call
            viewModel.fetchPost()
        }
    }
}
