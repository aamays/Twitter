//
//  MenuOptions.swift
//  Twitter
//
//  Created by Amay Singhal on 10/9/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation
import UIKit

protocol MenuOption: class {
    var title: String { get }
    var iconType: FontasticIconType { get }
    var isSelected: Bool { get set }
    var viewController: UIViewController { get set }
}


class HomeMenuOption: MenuOption {

    private let _title = "Home"
    var title: String {
        get {
            return _title
        }
    }

    private let _iconType = FontasticIconType.Home
    var iconType: FontasticIconType {
        get {
            return _iconType
        }
    }

    var selected: Bool!
    var isSelected: Bool {
        get {
            return selected
        }
        set(newValue) {
            selected = newValue
        }
    }

    var homeViewController: UIViewController!
    var viewController: UIViewController {
        get {
            return homeViewController
        }
        set(newViewController) {
            homeViewController = newViewController
        }
    }

    init(selected: Bool, viewController: UIViewController) {
        self.selected = selected
        self.viewController = viewController
    }
}

class ProfileMenuOption: MenuOption {
    private var _title = "Me"
    var title: String {
        get {
            return _title
        }
    }
    private var _iconType = FontasticIconType.UserFilled
    var iconType: FontasticIconType {
        get {
            return _iconType
        }
    }
    var selected: Bool!
    var isSelected: Bool {
        get {
            return selected
        }
        set(newValue) {
            selected = newValue
        }
    }
    var profileViewController: UIViewController!
    var viewController: UIViewController {
        get {
            return profileViewController
        }
        set(newViewController) {
            profileViewController = newViewController
        }
    }

    init(selected: Bool, viewController: UIViewController) {
        self.selected = selected
        self.viewController = viewController
    }
}


class MentionsMenuOption: MenuOption {

    private let _title = "Mentions"
    var title: String {
        get {
            return _title
        }
    }

    private let _iconType = FontasticIconType.AtSign
    var iconType: FontasticIconType {
        get {
            return _iconType
        }
    }

    var selected: Bool!
    var isSelected: Bool {
        get {
            return selected
        }
        set(newValue) {
            selected = newValue
        }
    }

    var homeViewController: UIViewController!
    var viewController: UIViewController {
        get {
            return homeViewController
        }
        set(newViewController) {
            homeViewController = newViewController
        }
    }

    init(selected: Bool, viewController: UIViewController) {
        self.selected = selected
        self.viewController = viewController
    }
}