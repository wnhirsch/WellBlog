//
//  Loadable.swift
//  WellBlog
//
//  Created by Wellington Nascente Hirsch on 21/06/23.
//

import UIKit

protocol Loadable {
    func showLoading(message: String?, on subview: UIView?)
    func hideLoading()
}

extension Loadable where Self: UIViewController {

    private func findLoadingView() -> Scene.Components.LoadingView? {
        return view.subviews.compactMap { $0 as? Scene.Components.LoadingView }.first
    }

    private func addLoadingView(subview: UIView? = nil) -> Scene.Components.LoadingView {
        let loadingView = Scene.Components.LoadingView()
        loadingView.startAnimating()
        
        if let superview = subview ?? view {
            superview.addSubview(loadingView)
            loadingView.snp.makeConstraints{ (make) -> Void in
                make.center.equalToSuperview()
            }
        }

        return loadingView
    }

    // MARK: - Public
    func showLoading(message: String? = nil, on subview: UIView? = nil) {
        view.endEditing(true)
        
        if let loadingView = findLoadingView() {
            loadingView.setup(message: message)
            view.bringSubviewToFront(loadingView)
            return
        }

        let loadingView = addLoadingView(subview: subview)
        loadingView.setup(message: message)
        loadingView.alpha = 1
    }

    func hideLoading() {
        guard let loadingView = findLoadingView() else {
            return
        }

        UIView.animate(withDuration: 0.25, animations: {
            loadingView.alpha = 0
        }, completion: { _ in
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        })
    }
    
}
