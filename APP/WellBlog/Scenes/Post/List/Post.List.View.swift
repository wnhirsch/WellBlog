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
        
        let newPostButton: UIButton = {
            let button = UIButton()
            button.setTitle("list.button".localized(context: .post), for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 10
            return button
        }()
        
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
            newPostButton.addTarget(self, action: #selector(didTapNewPostButton), for: .touchUpInside)
        }
        
        func setupEmptyMessage(isEmpty: Bool) {
            if isEmpty {
                let messageLabel = UILabel(frame: CGRect(
                    x: 0, y: 0,
                    width: tableView.bounds.size.width,
                    height: tableView.bounds.size.height
                ))
                messageLabel.text = "list.empty".localized(context: .post)
                messageLabel.textAlignment = .center
                messageLabel.font = .systemFont(ofSize: 16)
                messageLabel.textColor = .secondaryLabel
                messageLabel.sizeToFit()
                
                tableView.backgroundView = messageLabel
                tableView.separatorStyle = .none
            } else {
                tableView.backgroundView = nil
                tableView.separatorStyle = .singleLine
            }
        }

        @objc private func didTapNewPostButton() {
            newPostPublisher.send()
        }
    }
}
