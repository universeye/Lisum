//
//  MediaListTableViewCell.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class MediaListTableViewCell: UITableViewCell {
    static let reuseID = "MediaListTableViewCell"
    
    private let albumCoverImageView = AlbumCoverImageView(frame: .zero)
    private let assets = Assets()
    private let trackName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.8
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let albumNameLabel = LisumBodyLabel(textAlignment: .left)
    private let artistNameLabel = LisumBodyLabel(textAlignment: .left)
    private let stackView = UIStackView()
    private let explicitStackView = UIStackView()
    private let padding: CGFloat = 16
    private let explicitIndicator: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "e.square.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LisumColor.bgColor
        configureAlbumCover()
        configureExplicitIndicator()
        configureStackView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(mediaInfo: SearchResult.MediaInfo) {
        trackName.text = mediaInfo.trackName
        albumNameLabel.text = mediaInfo.collectionName
        artistNameLabel.text = mediaInfo.artistName
        
        if mediaInfo.trackExplicitness == "explicit" {
            explicitIndicator.isHidden = false
        } else {
            explicitIndicator.isHidden = true
        }
        
        
        Task {
            albumCoverImageView.image = await albumCoverImageView.downloadImageWithAsync(from: mediaInfo.artworkUrl100, trackId: String(mediaInfo.trackId)) ?? UIImage(named: assets.placeHolderImage)
        }
    }
    
    private func configureAlbumCover() {
        addSubview(albumCoverImageView)
        
        NSLayoutConstraint.activate([
            albumCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            albumCoverImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: 60),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureExplicitIndicator() {
        explicitStackView.axis = .horizontal
        explicitStackView.distribution = .fillProportionally
        explicitStackView.translatesAutoresizingMaskIntoConstraints = false
        explicitStackView.spacing = 4
        
        explicitStackView.addArrangedSubview(trackName)
        explicitStackView.addArrangedSubview(explicitIndicator)
        
        NSLayoutConstraint.activate([
            explicitIndicator.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        
        stackView.addArrangedSubview(explicitStackView)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.addArrangedSubview(albumNameLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: padding),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}
