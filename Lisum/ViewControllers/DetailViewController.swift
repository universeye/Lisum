//
//  DetailViewController.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/23.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        view.backgroundColor = LisumColor.bgColor
    }
}
