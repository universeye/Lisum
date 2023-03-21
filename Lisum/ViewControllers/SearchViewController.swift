//
//  SearchViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchTextField = LisumTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTextField()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Lisum"
    }
    
    private func configureTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func search() {
        let mediaListViewController = MediaListViewController2(searchTerm: searchTextField.text ?? "No Text")
        navigationController?.pushViewController(mediaListViewController, animated: true)
    }
    
    
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
}
