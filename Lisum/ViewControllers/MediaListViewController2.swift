//
//  MediaListViewController2.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class MediaListViewController2: UIViewController {
    
    var searchTerm: String!
    private var musics: [SearchResult.MediaInfo] = []
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(MediaListTableViewCell.self, forCellReuseIdentifier: MediaListTableViewCell.reuseID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableview()
        getMusic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    init(searchTerm: String) {
        super.init(nibName: nil, bundle: nil)
        self.searchTerm = searchTerm
        title = searchTerm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableview() {
        view.addSubview(tableView)
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func getMusic() {
        Task {
            do {
                let result = try await NetworkManager.shared.searchMusic(for: searchTerm)
                updateData(with: result.results)
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func updateData(with musics: [SearchResult.MediaInfo]) {
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
extension MediaListViewController2: UITableViewDelegate, UITableViewDataSource {
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
    }
    
}


