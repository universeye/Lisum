//
//  DetailActionButton.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/24.
//

import UIKit

class DetailActionButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, systemImageName: systemImageName)
    }
    
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        translatesAutoresizingMaskIntoConstraints = false //means use autoLayouts
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func set(color: UIColor, systemImageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.image = UIImage(systemName: systemImageName)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        configuration?.imagePadding = 6
    }
    
    
    
}
