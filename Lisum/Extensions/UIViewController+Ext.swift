//
//  UIViewController+Ext.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = LisumEmptyView(message: message)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.tag = 14
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func presentAlert(title: String, messgae: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = LisumAlertViewController(title: title, message: messgae, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }

    func add(_ child: UIViewController, in view: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = LisumColor.transblack
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let dotsAnimationView = DotsAnimationView(dotSize: .init(width: 10, height: 10), dotColor: .white, animationTime: 0.9)
        dotsAnimationView.startAnimation()
        containerView.addSubview(dotsAnimationView)
        
        dotsAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dotsAnimationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dotsAnimationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    func dimissLoadingView() {
        DispatchQueue.main.async {
            if containerView != nil {
                containerView.removeFromSuperview()
                containerView = nil
            }
        }
    }
    
    func showDetail(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.preferredControlTintColor = LisumColor.mainColor
            present(vc, animated: true)
        }
    }
    
}
