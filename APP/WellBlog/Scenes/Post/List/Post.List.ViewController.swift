//
//  Post.List.ViewController.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine
import UIKit

extension Scene.Post.List {

    class ViewController: UIViewController, Loadable {

        private let contentView: View
        private let viewModel: ViewModel
        private var isFirstAppearance = true
        
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
            
            navigationItem.title = "list.title".localized(context: .post)
            navigationItem.rightBarButtonItem = .init(
                barButtonSystemItem: .refresh,
                target: self,
                action: #selector(didTapRefreshButton)
            )
            
            bind()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
            
            if !isFirstAppearance {
                viewModel.refreshData()
            }
            isFirstAppearance = false
        }
        
        private func bind() {
            contentView.tableView.delegate = self
            contentView.tableView.dataSource = self
            
            // Loading event
            viewModel.$isLoading.sink { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showLoading() : self.hideLoading()
            }.store(in: &cancellables)
            
            // Load Posts Event
            viewModel.$posts
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.contentView.tableView.reloadData()
            }.store(in: &cancellables)
            
            // New Post Button click Event
            contentView.newPostPublisher.sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.goToCreatePost()
            }.store(in: &cancellables)
            
            // First API call
            viewModel.fetchPosts()
        }
        
        @objc private func didTapRefreshButton() {
            viewModel.refreshData()
        }
    }
}

extension Scene.Post.List.ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentView.setupEmptyMessage(isEmpty: viewModel.posts.isEmpty)
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(Scene.Post.List.Cell.self, for: indexPath)
        cell.setup(model: viewModel.posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.goToPostDetail(index: indexPath.row)
    }
}

extension Scene.Post.List.ViewController: UIScrollViewDelegate {
    
    // Detects if the user scroll down the table to load more Posts
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        // Verify if the table isn't loading to avoid multiple calls
        if !viewModel.isLoading && offsetY > (contentHeight - visibleHeight) {
            viewModel.fetchPosts()
        }
    }
}
