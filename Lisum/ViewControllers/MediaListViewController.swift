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
    private let pullUpView = UIView()
    private var arrowUp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    private let pullUpLoadingIndicator = UIView(frame: .zero)
    private var offsetY: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var height: CGFloat = 0
    
    
    //MARK: VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableview()
        showLoadingView()
        getMusic(offsetCount: offsetCount) { [weak self] in
            guard let self = self else { return }
            self.generateHapticFeedback(style: .light)
            self.dimissLoadingView()
        }
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
        configureFooterView()
    }
    
    private func configureFooterView() {
        pullUpView.backgroundColor = UIColor.clear
        arrowUp.translatesAutoresizingMaskIntoConstraints = false
        pullUpView.addSubview(arrowUp)
        NSLayoutConstraint.activate([
            arrowUp.centerXAnchor.constraint(equalTo:  pullUpView.centerXAnchor)
        ])
        arrowUp.image = UIImage(systemName: "arrow.up",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        pullUpView.alpha = 0.02
        
        pullUpLoadingIndicator.backgroundColor = UIColor.clear
        let dotsAnimationView = DotsAnimationView(dotSize: .init(width: 10, height: 10), dotColor: LisumColor.labelColor, animationTime: 0.9)
        dotsAnimationView.translatesAutoresizingMaskIntoConstraints = false
        dotsAnimationView.startAnimation()
        pullUpLoadingIndicator.addSubview(dotsAnimationView)
        NSLayoutConstraint.activate([
            dotsAnimationView.centerXAnchor.constraint(equalTo:  pullUpLoadingIndicator.centerXAnchor)
        ])
        
        tableView.tableFooterView = pullUpView
    }
    
    //MARK: Functions
    private func getMusic(offsetCount: Int, completion: @escaping () -> Void) {
        Task {
            do {
                let data = try await NetworkManager.shared.searchMusic(for: searchTerm, offsetCount: offsetCount)
                updateData(with: data.results)
                completion()
            } catch {
                if let error = error as? LisumError {
                    self.presentAlert(title: "Error😵", messgae: error.rawValue, buttonTitle: "Ok")
                } else {
                    self.presentAlert(title: "Error😵", messgae: error.localizedDescription, buttonTitle: "Ok")
                }
                updateData(with: [])
                completion()
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
        self.generateHapticFeedback(style: .light)
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


//MARK: - ScrollView Delegate
extension MediaListViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !musics.isEmpty else { return }
        if (offsetY - 150) > contentHeight - height {
            tableView.tableFooterView = pullUpLoadingIndicator
            guard hasMoreMusics else {
                self.showToast(message: "No more music !", font: .systemFont(ofSize: 14))
                self.pullUpView.alpha = 0
                self.pullUpLoadingIndicator.alpha = 0
                return
            }
            offsetCount = musics.count
            getMusic(offsetCount: offsetCount) { [weak self] in
                guard let self = self else { return }
                self.pullUpLoadingIndicator.alpha = 0
            }
        }
        
        UIView.animate(withDuration: 0.14, delay: 0.01) {
            self.pullUpView.alpha = 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !musics.isEmpty else { return }
        offsetY = scrollView.contentOffset.y
        contentHeight = scrollView.contentSize.height
        height = scrollView.frame.size.height
        
        if (offsetY - 120) > contentHeight - height {
            self.generateHapticFeedback(style: .light)
            UIView.animate(withDuration: 0.14, delay: 0.01) {
                self.arrowUp.image = UIImage(systemName: "magnifyingglass",
                                             withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            }
        } else {
            UIView.animate(withDuration: 0.14, delay: 0.01) {
                self.arrowUp.image = UIImage(systemName: "arrow.up",
                                             withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard !musics.isEmpty else { return }
        tableView.tableFooterView = pullUpView
        UIView.animate(withDuration: 0.14, delay: 0.01) {
            self.pullUpView.alpha = 1
            self.pullUpLoadingIndicator.alpha = 1
        }
    }
}
