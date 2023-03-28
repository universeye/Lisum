//
//  TitleView.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/28.
//

import UIKit

class TitleView: UIView {
    
    //MARK: Properties
    private let titleLabel = LisumTitleLabel(textAlignment: .left, fontSize: 40)
    private let titleLabel2 = LisumTitleLabel(textAlignment: .left, fontSize: 40)
    private let assets = Assets()
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configurations
    private func configure() {
        titleLabel.text = "Discover Music"
        titleLabel2.text = "in"
        logoImageView.image = UIImage(named: assets.lisumLogo)
        
        addSubview(titleLabel)
        addSubview(titleLabel2)
        addSubview(logoImageView)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleLabel2.topAnchor),
            
            titleLabel2.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleLabel2.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel2.widthAnchor.constraint(equalToConstant: 45),
            
            logoImageView.leadingAnchor.constraint(equalTo: titleLabel2.trailingAnchor),
            logoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150)
            
        ])
    }

}
