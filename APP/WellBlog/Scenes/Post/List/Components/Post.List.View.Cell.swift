//
//  Post.List.View.Cell.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import UIKit
import SnapKit

extension Scene.Post.List {
    
    class Cell: UITableViewCell, CodeView {
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .label
            label.numberOfLines = 1
            return label
        }()
        
        private let dateLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.textColor = .label
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func buildViewHierarchy() {
            addSubview(stackView)
            
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(dateLabel)
        }
        
        func setupConstraints() {
            stackView.snp.makeConstraints { (make) -> Void in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.verticalEdges.equalToSuperview().inset(8)
            }
        }
        
        func setupAdditionalConfiguration() { }
        
        func setup(model: Model.Post) {
            titleLabel.text = model.title
            if let date = model.createdAt {
                dateLabel.text = "post.date".localized(
                    context: .postList,
                    date.formatted(date: .numeric, time: .omitted)
                )
            }
        }
        
    }
    
}
