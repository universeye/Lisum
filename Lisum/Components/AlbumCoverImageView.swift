//
//  AlbumCoverImageView.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class AlbumCoverImageView: UIImageView {

    private let assets = Assets()
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let placeholderImage = UIImage(named: assets.placeHolderImage)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImageWithAsync(from url: URL?, trackId: String) async -> UIImage? {
        let cacheKey = NSString(string: trackId)
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = url else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
