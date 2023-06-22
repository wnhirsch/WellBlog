//
//  String+Localizable.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import Foundation

enum LocalizableFiles: String {
    case `default` = "Default"
    case post = "Post"
}

extension String {
    
    func localized(context: LocalizableFiles) -> String {
        return NSLocalizedString(self, tableName: context.rawValue, value: "", comment: "")
    }
    
    func localized(context: LocalizableFiles, _ args: CVarArg...) -> String {
        return String(
            format: NSLocalizedString(self, tableName: context.rawValue, value: "", comment: ""),
            arguments: args
        )
    }
}
