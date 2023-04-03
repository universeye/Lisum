//
//  Constants.swift
//  Lisum
//
//  Created by Terry Kuo on 2023/3/20.
//

import UIKit

struct Assets {
    let lisumLogo = "lisumlogo"
    let placeHolderImage = "lisumsq"
    let emptyStateImage = UIImage(named: "lisumEmptyState")
    let searchPageIllustrator = UIImage(named: "listenMusic1")
    let padding: CGFloat = 20
}

struct LisumColor {
    static let mainColor = UIColor(named: "mainColor")!
    static let bgColor = UIColor(named: "bgColor")!
    static let containerBgColor = UIColor(named: "containerBGColor")!
    static let transblack = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
    static let labelColor = UIColor(named: "labelColor")!
}

struct AlertMessage {
    static let emptyAlertTitle = "Textfield Empty!"
    static let emptyAlertMessage = "Enter something to find music!"
}
