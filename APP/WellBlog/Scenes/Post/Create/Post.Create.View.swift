//
//  Post.Create.View.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine
import SnapKit
import UIKit

extension Scene.Post.Create {
    
    class View: UIView, CodeView {
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 24
            return stackView
        }()
        
        let titleField: UITextField = {
            let field = UITextField()
            field.placeholder = "create.field.title".localized(context: .post)
            field.borderStyle = .roundedRect
            field.font = .systemFont(ofSize: 16)
            return field
        }()
        
        let descriptionField: UITextView = {
            let field = UITextView()
            field.isScrollEnabled = true
            field.isEditable = true
            field.layer.borderWidth = 0.6
            field.layer.borderColor = UIColor.quaternaryLabel.cgColor
            field.layer.cornerRadius = 5
            field.font = .systemFont(ofSize: 16)
            field.addPlaceholder("create.field.description".localized(context: .post))
            return field
        }()
        
        let createPostButton: UIButton = {
            let button = UIButton()
            button.setTitle("create.button".localized(context: .post), for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 10
            return button
        }()
        
        let createPostPublisher = PassthroughSubject<Void, Never>()
        
        init() {
            super.init(frame: .zero)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func buildViewHierarchy() {
            addSubview(stackView)
            addSubview(createPostButton)
            
            stackView.addArrangedSubview(titleField)
            stackView.addArrangedSubview(descriptionField)
        }
        
        func setupConstraints() {
            stackView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            createPostButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(stackView.snp.bottom).offset(16)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                make.height.equalTo(40)
            }
        }
        
        func setupAdditionalConfiguration() {
            backgroundColor = .systemBackground
            createPostButton.addTarget(self, action: #selector(didTapCreatePostButton), for: .touchUpInside)
        }
        
        @objc private func didTapCreatePostButton() {
            createPostPublisher.send()
        }
    }
}
