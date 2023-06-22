//
//  Post.Create.ViewController.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine
import UIKit

extension Scene.Post.Create {

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
        
        deinit {
            cancellables.forEach { $0.cancel() }
        }
        
        override func loadView() {
            view = contentView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "create.title".localized(context: .post)
            bind()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        private func bind() {
            contentView.titleField.delegate = self
            contentView.descriptionField.delegate = self
            
            // Loading event
            viewModel.$isLoading.sink { [weak self] isLoading in
                guard let self = self else { return }
                self.contentView.createPostButton.enable(!isLoading)
                isLoading ? self.showLoading() : self.hideLoading()
            }.store(in: &cancellables)
            
            // Create Post Button click Event
            contentView.createPostPublisher.sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.createPost()
            }.store(in: &cancellables)
            
            // If some parameter changes, the button state is recalculated
            viewModel.$title.merge(with: viewModel.$description)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let self = self else { return }
                    self.contentView.createPostButton.enable(
                        viewModel.isTitleValid() && viewModel.isDescriptionValid()
                    )
            }.store(in: &cancellables)
        }
    }
}

extension Scene.Post.Create.ViewController: UITextFieldDelegate, UITextViewDelegate {

    // Title Update Event
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.title = textField.text ?? ""
    }
    
    // Description Update Event
    func textViewDidChange(_ textView: UITextView) {
        viewModel.description = textView.text
    }
}
