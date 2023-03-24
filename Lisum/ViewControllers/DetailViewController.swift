//
//  DetailViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/23.
//

import UIKit

class DetailViewController: UIViewController {

    private var loadingViewController: LoadingViewController?
    let trackId: Int
    private let containerViewForAlubumCover = LisumContainerView(backgroundColor: LisumColor.containerBgColor)
    private let containerViewForDetailLabel = LisumContainerView(backgroundColor: LisumColor.containerBgColor)
    private let albumCoverImageView = AlbumCoverImageView(frame: .zero)
    private var musicInfo: [LookUpResult.MediaInfo] = []
    private let assets = Assets()
    private let artistPreviewButton = DetailActionButton(color: .white, systemImageName: "person.fill")
    private let albumPreviewButton = DetailActionButton(color: .white, systemImageName: "text.book.closed.fill")
    private let playButton = DetailActionButton(color: LisumColor.mainColor, systemImageName: "play.fill")
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        lookUpMusic(trackId: trackId)
        configureAlbumCoverSection()
        configureDetailSection()
        configureButtonSection()
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
    
    private func configureAlbumCoverSection() {
        view.addSubview(containerViewForAlubumCover)
        containerViewForAlubumCover.layer.borderWidth = 0
        containerViewForAlubumCover.addSubview(albumCoverImageView)
        
        NSLayoutConstraint.activate([
            containerViewForAlubumCover.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerViewForAlubumCover.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerViewForAlubumCover.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            containerViewForAlubumCover.heightAnchor.constraint(equalToConstant: 130),
            
            albumCoverImageView.centerXAnchor.constraint(equalTo: containerViewForAlubumCover.centerXAnchor),
            albumCoverImageView.centerYAnchor.constraint(equalTo: containerViewForAlubumCover.centerYAnchor),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: 100),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureDetailSection() {
        view.addSubview(containerViewForDetailLabel)
        containerViewForDetailLabel.layer.borderWidth = 0
        
        NSLayoutConstraint.activate([
            containerViewForDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerViewForDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerViewForDetailLabel.topAnchor.constraint(equalTo: containerViewForAlubumCover.bottomAnchor, constant: 16),
            containerViewForDetailLabel.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func configureButtonSection() {
        stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.spacing = 10
                
                stackView.addArrangedSubview(artistPreviewButton)
                stackView.addArrangedSubview(albumPreviewButton)
                stackView.addArrangedSubview(playButton)
                
                view.addSubview(stackView)
                
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: containerViewForDetailLabel.bottomAnchor, constant: 16),
                    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
                ])
    }
    
    private func lookUpMusic(trackId: Int) {
        Task {
            do {
//                startLoading(vc: &loadingViewController)
                let data = try await NetworkManager.shared.lookUpMusic(for: String(trackId))
                print(data.results[0].trackName)
                self.musicInfo.append(contentsOf: data.results)
                let albumCoverImage = await albumCoverImageView.downloadImageWithAsync(from: data.results[0].artworkUrl100, trackId: String(data.results[0].trackId)) ?? UIImage(named: assets.placeHolderImage)
                albumCoverImageView.image = albumCoverImage
//                stopLoading(vc: &loadingViewController)
            } catch {
                if let error = error as? LisumError {
                    self.presentAlert(title: "Error😵", messgae: error.rawValue, buttonTitle: "Ok")
                }
//                stopLoading(vc: &loadingViewController)
            }
        }
    }
}
