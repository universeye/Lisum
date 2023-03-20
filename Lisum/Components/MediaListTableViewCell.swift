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
        return label
    }()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(mediaInfo: SearchResult.MediaInfo) {
        self.trackName.text = mediaInfo.trackName
        Task {
            albumCoverImageView.image = await albumCoverImageView.downloadImageWithAsync(from: mediaInfo.artworkUrl100, trackId: mediaInfo.trackName) ?? UIImage(named: assets.placeHolderImage)
        }
    }
    
    private func configure() {
        addSubview(albumCoverImageView)
        addSubview(trackName)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            albumCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            albumCoverImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: 50),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: 50),
            
            trackName.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: padding),
            trackName.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            trackName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            trackName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }

}
