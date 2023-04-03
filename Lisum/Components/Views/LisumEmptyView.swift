//
//  LisumEmptyView.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class LisumEmptyView: UIView {

    private let titleLabel = LisumTitleLabel(textAlignment: .center, fontSize: 28)
    private let assets = Assets()
    private let emptyImage: UIImageView = {
       let imageView =  UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        titleLabel.text = message
    }
    
    private func configure() {
        addSubview(emptyImage)
        addSubview(titleLabel)
        
        emptyImage.image = assets.emptyStateImage!.withRenderingMode(.alwaysTemplate)
        emptyImage.tintColor = .secondaryLabel
        titleLabel.numberOfLines = 3
        titleLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            emptyImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            emptyImage.heightAnchor.constraint(equalToConstant: 160),
            emptyImage.widthAnchor.constraint(equalToConstant: 160),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

}
