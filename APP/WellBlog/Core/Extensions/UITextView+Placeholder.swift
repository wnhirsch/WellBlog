//
//  UITextView+Placeholder.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 22/06/23.
//

import UIKit

extension UITextView {
    
    func addPlaceholder(_ placeholder: String, placeholderColor: UIColor = .placeholderText) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 999
        self.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 8, y: 8)
        placeholderLabel.isHidden = !self.text.isEmpty
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func textDidChange() {
        let placeholderLabel = self.viewWithTag(999) as? UILabel
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}
