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
    let emptyStateImage = "empty-state-logo"
    let searchPageIllustrator = "listenMusic1"
    let padding: CGFloat = 20
}

struct LisumColor {
    static let mainColor = UIColor(named: "mainColor")!
    static let bgColor = UIColor(named: "bgColor")!
    static let containerBgColor = UIColor(named: "containerBGColor")!
    static let transblack = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
}

struct AlertMessage {
    static let emptyAlertTitle = "Textfield Empty!"
    static let emptyAlertMessage = "Enter something to find music!"
}
