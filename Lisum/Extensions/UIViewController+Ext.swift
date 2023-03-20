//
//  UIViewController+Ext.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

extension UIViewController {
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = LisumEmptyView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
