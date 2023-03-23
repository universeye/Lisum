//
//  LisumContainerView.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class LisumContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor = .systemBackground) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        
    }
    
    private func configure() {
        layer.cornerRadius = 16
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = LisumColor.mainColor.cgColor
    }

}
