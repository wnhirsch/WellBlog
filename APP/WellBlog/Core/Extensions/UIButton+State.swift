//
//  UIButton+State.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 22/06/23.
//

import UIKit

extension UIButton {
    
    func enable(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(isEnabled ? 1.0 : 0.5)
        }
    }
}
