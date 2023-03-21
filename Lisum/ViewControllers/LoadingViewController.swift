//
//  LoadingViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/21.
//

import UIKit

class LoadingViewController: UIViewController {

    private let containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return containerView
    }()
    
    private let dotsAnimationView = DotsAnimationView(dotSize: .init(width: 10, height: 10), dotColor: .white, animationTime: 0.9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 140),
            containerView.widthAnchor.constraint(equalToConstant: 140)
        ])
        setupUI()
        startAnimation()
    }
    
    func setupUI() {
        dotsAnimationView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dotsAnimationView)
        dotsAnimationView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dotsAnimationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        dotsAnimationView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        dotsAnimationView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    }
    
    func startAnimation() {
        dotsAnimationView.startAnimation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            UIView.animate(withDuration: 1) {
                self?.view.alpha = 1
            }
        }
    }
}
