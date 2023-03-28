//
//  DetailViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/23.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    let trackId: Int
    private let containerView = LisumContainerView(backgroundColor: LisumColor.containerBgColor)
    private let albumCoverImageView = AlbumCoverImageView(frame: .zero)
    private var musicInfo: LookUpResult.MediaInfo?
    private let assets = Assets()
    private let artistPreviewButton = DetailActionButton(color: .white, systemImageName: "person.fill")
    private let albumPreviewButton = DetailActionButton(color: .white, systemImageName: "text.book.closed.fill")
    private let playButton = DetailActionButton(color: LisumColor.mainColor, systemImageName: "play.fill")
    private let stackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let detailLabelView = DetailLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        lookUpMusic(trackId: trackId)
        
        configureAlbumCoverSection()
        configureButtonSection()
        configureStackView()
    }
    
    init(trackId: Int) {
        self.trackId = trackId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureVC() {
        view.backgroundColor = LisumColor.bgColor
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureAlbumCoverSection() {
        containerView.layer.borderWidth = 0
        detailLabelView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(albumCoverImageView)
        containerView.addSubview(detailLabelView)
        
        NSLayoutConstraint.activate([
            albumCoverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            albumCoverImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: 100),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: 100),
            
            detailLabelView.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 16),
            detailLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            detailLabelView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            detailLabelView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureButtonSection() {
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.spacing = 10
        
        artistPreviewButton.addTarget(self, action: #selector(showArtistDetail), for: .touchUpInside)
        albumPreviewButton.addTarget(self, action: #selector(showAlbumDetail), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(showSongDetail), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(artistPreviewButton)
        buttonStackView.addArrangedSubview(albumPreviewButton)
        buttonStackView.addArrangedSubview(playButton)
    }
    
    private func lookUpMusic(trackId: Int) {
        Task {
            showLoadingView()
            do {
                let data = try await NetworkManager.shared.lookUpMusic(for: String(trackId))
                self.musicInfo = data.results[0]
                let albumCoverImage = await albumCoverImageView.downloadImageWithAsync(from: data.results[0].artworkUrl100, trackId: String(data.results[0].trackId)) ?? UIImage(named: assets.placeHolderImage)
                albumCoverImageView.image = albumCoverImage
                detailLabelView.setValue(title: musicInfo?.trackName ?? "N/A", artist: musicInfo?.artistName ?? "N/A", album: musicInfo?.collectionName ?? "N/A", releaseDate: musicInfo?.artistName ?? "N/A")
                dimissLoadingView()
            } catch {
                if let error = error as? LisumError {
                    self.presentAlert(title: "Error😵", messgae: error.rawValue, buttonTitle: "Ok")
                } else {
                    self.presentAlert(title: "Error😵", messgae: error.localizedDescription, buttonTitle: "Ok")
                }
                dimissLoadingView()
            }
            
        }
        
    }
    
    @objc private func showArtistDetail() {
        self.showDetail(musicInfo?.artistViewUrl ?? "")
    }
    
    @objc private func showAlbumDetail() {
        self.showDetail(musicInfo?.collectionViewUrl ?? "")
    }
    
    @objc private func showSongDetail() {
        self.showDetail(musicInfo?.previewUrl ?? "")
    }
    
    func showDetail(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.preferredControlTintColor = LisumColor.mainColor
            present(vc, animated: true)
        }
    }
}
