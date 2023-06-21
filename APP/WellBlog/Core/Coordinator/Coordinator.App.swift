//
//  Coordinator.App.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import UIKit

extension Coordinator {
    
    class App {

        private let window: UIWindow
        private(set) var childCoordinator: CoordinatorProtocol?

        init(window: UIWindow) {
            self.window = window
        }

        func start() {
            let postCoordinator = Coordinator.Post()
            postCoordinator.start()
            childCoordinator = postCoordinator
            window.rootViewController = postCoordinator.containerViewController
            window.makeKeyAndVisible()
        }
    }
}
