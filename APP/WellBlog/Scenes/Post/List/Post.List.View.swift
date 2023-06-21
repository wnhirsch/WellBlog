//
//  Post.List.View.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Combine
import SnapKit
import UIKit

extension Scene.Post.List {
    
    class View: UIView, CodeView {
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.register(Cell.self)
            return tableView
        }()
        
        private let newPostButton: UIButton = {
            let button = UIButton()
            button.setTitle("create.post.button".localized(context: .postList), for: .normal)
            button.backgroundColor = .secondaryLabel
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 10
            return button
        }()
        
        private var cancellables = Set<AnyCancellable>()
        let newPostPublisher = PassthroughSubject<Void, Never>()
        
        init() {
            super.init(frame: .zero)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func buildViewHierarchy() {
            addSubview(tableView)
            addSubview(newPostButton)
        }
        
        func setupConstraints() {
            tableView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                make.horizontalEdges.equalToSuperview()
            }
            
            newPostButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(tableView.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                make.height.equalTo(40)
            }
        }
        
        func setupAdditionalConfiguration() {
            backgroundColor = .systemBackground
            tableView.backgroundColor = .clear
            newPostButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        
        @objc private func buttonAction() {
            newPostPublisher.send()
        }
    }
}
