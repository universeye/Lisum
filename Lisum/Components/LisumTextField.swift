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
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor //do bordoer color, need to use CGColor not UIColor, so you have to type out full UIColor
        
        textColor = .label //black on lightmode, white on darkmode
        tintColor = .label //blinking cursur
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .search
        placeholder = "Enter Text"
        clearButtonMode = .whileEditing
    }

}
