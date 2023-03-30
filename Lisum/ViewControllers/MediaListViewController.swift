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
    private let refreshControlll = UIRefreshControl()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = LisumColor.bgColor
        tableView.register(MediaListTableViewCell.self, forCellReuseIdentifier: MediaListTableViewCell.reuseID)
        return tableView
    }()
    private var isEmpty: Bool = false
    
    let vw = UIView()
    var offsetY: CGFloat = 0
    var contentHeight: CGFloat = 0
    var height: CGFloat = 0
    var percentage: CGFloat = 0
    
    //MARK: VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableview()
        getMusic(offsetCount: offsetCount) {}
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
        tableView.addSubview(refreshControlll)
        refreshControlll.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
       
        vw.backgroundColor = UIColor.clear
        let arrowUp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        arrowUp.translatesAutoresizingMaskIntoConstraints = false
        vw.addSubview(arrowUp)
        NSLayoutConstraint.activate([
            arrowUp.centerXAnchor.constraint(equalTo:  vw.centerXAnchor)
        ])
        arrowUp.image = UIImage(systemName: "arrow.up")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        vw.alpha = 0.02
        tableView.tableFooterView = vw
    }
    
    //MARK: Functions
    private func getMusic(offsetCount: Int, completion: @escaping () -> Void) {
        Task {
            do {
                showLoadingView()
                let data = try await NetworkManager.shared.searchMusic(for: searchTerm, offsetCount: offsetCount)
                updateData(with: data.results)
                completion()
                dimissLoadingView()
            } catch {
                if let error = error as? LisumError {
                    self.presentAlert(title: "Error😵", messgae: error.rawValue, buttonTitle: "Ok")
                } else {
                    self.presentAlert(title: "Error😵", messgae: error.localizedDescription, buttonTitle: "Ok")
                }
                updateData(with: [])
                completion()
                dimissLoadingView()
                
            }
        }
    }
    
    private func updateData(with musics: [SearchResult.MediaInfo]) {
        if musics.count < 50 {
            hasMoreMusics = false
        }
        isEmpty = false
        self.musics.append(contentsOf: musics)
        if musics.isEmpty {
            isEmpty = true
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "No Musics", in: self.tableView)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: Refresh Actions
    @objc private func refresh(_ sender: AnyObject) {
        if isEmpty {
            if let viewWithTag = self.tableView.viewWithTag(14) {
                viewWithTag.removeFromSuperview()
            }
        }
        musics = []
        getMusic(offsetCount: 0) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.refreshControlll.endRefreshing()
            }
        }
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
         offsetY = scrollView.contentOffset.y
         contentHeight = scrollView.contentSize.height
         height = scrollView.frame.size.height
        
        print("offsetY = \(offsetY)")
        print("contentHeight = \(contentHeight)")
        print("height = \(height)")
        percentage = (offsetY - (contentHeight/50)) / (contentHeight - height)
        vw.alpha = percentage
        print("Percentage = \(percentage)")
        if (offsetY - (contentHeight/50)) > contentHeight - height {
            guard hasMoreMusics else {
                self.showToast(message: "No more music!", font: .systemFont(ofSize: 14))
                return
            }
            offsetCount = musics.count
            getMusic(offsetCount: offsetCount) {}
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = NSString(string: String(musics[indexPath.row].trackId))
        
        let config = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu(title: "Actions", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: []) }
            let artistAction = UIAction(title: "Go to Artist", image: UIImage(systemName: "person.fill"), identifier: nil, discoverabilityTitle: nil, state: .off) { _  in
                self.showDetail(self.musics[indexPath.row].artistViewUrl ?? "")
            }
            let albumAction = UIAction(title: "Go to Album", image: UIImage(systemName: "text.book.closed.fill"), identifier: nil, discoverabilityTitle: nil, state: .off) { _  in
                self.showDetail(self.musics[indexPath.row].collectionViewUrl ?? "")
            }
            let previewAction = UIAction(title: "Preview Track", image: UIImage(systemName: "play.fill"), identifier: nil, discoverabilityTitle: nil, state: .off) { _  in
                self.showDetail(self.musics[indexPath.row].previewUrl ?? "")
            }
            return UIMenu(title: "Actions", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [artistAction, albumAction, previewAction])
        }
        return config
        
    }
}


