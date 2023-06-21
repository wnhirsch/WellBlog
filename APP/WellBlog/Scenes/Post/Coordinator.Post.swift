//
//  Coordinator.Post.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import UIKit

extension Coordinator {
    
    class Post: CoordinatorProtocol {

        var childCoordinator: CoordinatorProtocol?
        weak var childDelegate: ChildCoordinatorDelegate?

        var containerViewController: UIViewController {
            return navigationController
        }
        
        private let navigationController = UINavigationController()
        
        func start() {
            let vc = Scene.Post.List.ViewController(viewModel: .init(coordinator: self))
            navigationController.pushViewController(vc, animated: true)
        }
        
        func showError(handler: ((UIAlertAction) -> Void)? = nil) {
            let alert = UIAlertController(
                title: "error.title".localized(context: .default),
                message: "error.message".localized(context: .default),
                preferredStyle: .alert
            )
            let tryAgainAction = UIAlertAction(
                title: "error.tryAgain".localized(context: .default),
                style: .default,
                handler: handler
            )
            alert.addAction(tryAgainAction)
            navigationController.present(alert, animated: true)
        }
    }
    
}
