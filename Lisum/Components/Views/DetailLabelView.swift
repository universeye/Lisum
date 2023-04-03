//
//  DetailLabelView.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/27.
//

import UIKit

class DetailLabelView: UIView {
    
    private let trackTitleLabel = LisumBodyLabel(textAlignment: .left)
    private let artistTitleLabel = LisumBodyLabel(textAlignment: .left)
    private let albumTitleLabel = LisumBodyLabel(textAlignment: .left)
    private let releaseDateTitleLabel = LisumBodyLabel(textAlignment: .left)
    
    private let titleStackView = UIStackView()
    private let valueStackView = UIStackView()
    
    private let trackValueLabel = LisumTitleLabel(textAlignment: .right, fontSize: 16)
    private let artistValueLabel = LisumTitleLabel(textAlignment: .right, fontSize: 16)
    private let albumValueLabel = LisumTitleLabel(textAlignment: .right, fontSize: 16)
    private let releaseDateValueLabel = LisumTitleLabel(textAlignment: .right, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setValue(title: String, artist: String, album: String, releaseDate: String) {
        self.trackValueLabel.text = title
        self.artistValueLabel.text = artist
        self.albumValueLabel.text = album
        self.releaseDateValueLabel.text = releaseDate
    }
    
    private func configureStackView() {
        addSubview(titleStackView)
        addSubview(valueStackView)
        
        titleStackView.addArrangedSubview(trackTitleLabel)
        titleStackView.addArrangedSubview(artistTitleLabel)
        titleStackView.addArrangedSubview(albumTitleLabel)
        titleStackView.addArrangedSubview(releaseDateTitleLabel)
        
        valueStackView.addArrangedSubview(trackValueLabel)
        valueStackView.addArrangedSubview(artistValueLabel)
        valueStackView.addArrangedSubview(albumValueLabel)
        valueStackView.addArrangedSubview(releaseDateValueLabel)
        
        titleStackView.axis = .vertical
        titleStackView.distribution = .fillEqually
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.spacing = 16
        
        valueStackView.axis = .vertical
        valueStackView.distribution = .fillEqually
        valueStackView.translatesAutoresizingMaskIntoConstraints = false
        valueStackView.spacing = 16
        
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleStackView.widthAnchor.constraint(equalToConstant: 90),
            
            valueStackView.topAnchor.constraint(equalTo: topAnchor),
            valueStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueStackView.leadingAnchor.constraint(equalTo: titleStackView.trailingAnchor)
        ])
    }
    
    private func configure() {
        trackTitleLabel.text = "Track: "
        artistTitleLabel.text = "Artist: "
        albumTitleLabel.text = "Album: "
        releaseDateTitleLabel.text = "Release Date: "
        
        releaseDateTitleLabel.numberOfLines = 2
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
