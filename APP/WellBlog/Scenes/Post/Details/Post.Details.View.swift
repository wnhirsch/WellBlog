//
//  Post.Details.View.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine
import SnapKit
import UIKit

extension Scene.Post.Details {
    
    class View: UIView, CodeView {
        
        private let scrollView = UIScrollView()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "details.post.title".localized(context: .post)
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .label
            return label
        }()
        
        private let titlePostLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .label
            label.numberOfLines = 0
            return label
        }()
        
        private let dateLabel: UILabel = {
            let label = UILabel()
            label.text = "details.post.date".localized(context: .post)
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .label
            return label
        }()
        
        private let datePostLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .label
            label.numberOfLines = 0
            return label
        }()
        
        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = "details.post.description".localized(context: .post)
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .label
            return label
        }()
        
        private let descriptionPostLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .label
            label.numberOfLines = 0
            return label
        }()
        
        let deletePostButton: UIButton = {
            let button = UIButton()
            button.setTitle("details.button".localized(context: .post), for: .normal)
            button.backgroundColor = .systemRed
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 10
            return button
        }()
        
        private var cancellables = Set<AnyCancellable>()
        let deletePostPublisher = PassthroughSubject<Void, Never>()
        
        init() {
            super.init(frame: .zero)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func buildViewHierarchy() {
            addSubview(scrollView)
            addSubview(deletePostButton)
            
            scrollView.addSubview(stackView)
            
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(titlePostLabel)
            stackView.addArrangedSubview(dateLabel)
            stackView.addArrangedSubview(datePostLabel)
            stackView.addArrangedSubview(descriptionLabel)
            stackView.addArrangedSubview(descriptionPostLabel)
        }
        
        func setupConstraints() {
            scrollView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                make.horizontalEdges.equalToSuperview()
            }
            
            stackView.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview().inset(16)
                make.width.equalToSuperview().inset(16)
            }
            
            deletePostButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(scrollView.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                make.height.equalTo(40)
            }
            
            stackView.setCustomSpacing(24, after: titlePostLabel)
            stackView.setCustomSpacing(24, after: datePostLabel)
        }
        
        func setupAdditionalConfiguration() {
            backgroundColor = .systemBackground
            deletePostButton.addTarget(self, action: #selector(didTapDeletePostButton), for: .touchUpInside)
        }
        
        func setup(model: Model.Post) {
            titlePostLabel.text = model.title
            if let date = model.createdAt {
                datePostLabel.text = date.formatted(date: .numeric, time: .shortened)
            }
            descriptionPostLabel.text = model.description
        }
        
        @objc private func didTapDeletePostButton() {
            deletePostPublisher.send()
        }
    }
}
