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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        lookUpMusic(trackId: trackId)
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
    
    private func lookUpMusic(trackId: Int) {
        Task {
            do {
//                startLoading(vc: &loadingViewController)
                let data = try await NetworkManager.shared.lookUpMusic(for: String(trackId))
                print(data.results[0].trackName)
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
