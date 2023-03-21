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
    private let padding: CGFloat = 16
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = LisumColor.bgColor
        configureAlbumCover()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(mediaInfo: SearchResult.MediaInfo) {
        trackName.text = mediaInfo.trackName
        albumNameLabel.text = mediaInfo.collectionName
        artistNameLabel.text = mediaInfo.artistName
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
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        
        stackView.addArrangedSubview(trackName)
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
