//
//  MediaListViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class MediaListViewController: UIViewController {
    
    //MARK: Properties
    var searchTerm: String
    private var musics: [SearchResult.MediaInfo] = []
    private var loadingViewController: LoadingViewController?
    private var hasMoreMusics: Bool = true
    private var offsetCount = 0
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = LisumColor.bgColor
        tableView.register(MediaListTableViewCell.self, forCellReuseIdentifier: MediaListTableViewCell.reuseID)
        return tableView
    }()
    
    //MARK: VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableview()
        getMusic(offsetCount: offsetCount)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    //MARK: Initializers
    init(searchTerm: String) {
        self.searchTerm = searchTerm
        super.init(nibName: nil, bundle: nil)
        title = searchTerm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configurations
    private func configureVC() {
        view.backgroundColor = LisumColor.bgColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: LisumColor.mainColor]
    }
    
    private func configureTableview() {
        view.addSubview(tableView)
        tableView.rowHeight = 90
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.indicatorStyle = .default
    }
    
    //MARK: Functions
    private func getMusic(offsetCount: Int) {
        Task {
            do {
                startLoading(vc: &loadingViewController)
                let data = try await NetworkManager.shared.searchMusic(for: searchTerm, offsetCount: offsetCount)
                updateData(with: data.results)
                stopLoading(vc: &loadingViewController)
            } catch {
                if let error = error as? LisumError {
                    self.presentAlert(title: "Error😵", messgae: error.rawValue, buttonTitle: "Ok")
                } else {
                   self.presentAlert(title: "Error😵", messgae: error.localizedDescription, buttonTitle: "Ok")
               }
                showEmptyStateView(with: "No Musics", in: self.view)
                stopLoading(vc: &loadingViewController)
                
            }
        }
    }
    
    private func updateData(with musics: [SearchResult.MediaInfo]) {
        if musics.count < 50 {
            hasMoreMusics = false
        }
        self.musics.append(contentsOf: musics)
        if musics.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "No Musics", in: self.view)
            }
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MediaListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaListTableViewCell.reuseID, for: indexPath) as? MediaListTableViewCell else {
            fatalError()
        }
        cell.set(mediaInfo: musics[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let smallId = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
            return 240
        }
        let vc = DetailViewController(trackId: musics[indexPath.row].trackId)
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [smallDetent, .medium()]
            presentationController.prefersGrabberVisible = true
        }
        self.present(vc, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreMusics else {
                return
            }
            
            offsetCount = musics.count
            getMusic(offsetCount: offsetCount)
        }
    }
}


