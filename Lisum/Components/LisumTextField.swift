//
//  LisumTextField.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class LisumTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        withImage(direction: .Left, image: UIImage(systemName: "magnifyingglass")!, colorSeparator: LisumColor.mainColor, colorBorder: .yellow)
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = LisumColor.mainColor.cgColor
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        returnKeyType = .search
        placeholder = "Search"
        clearButtonMode = .whileEditing
        
        layer.shadowColor = LisumColor.mainColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.3
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

}

