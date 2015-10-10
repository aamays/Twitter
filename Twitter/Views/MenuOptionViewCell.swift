//
//  MenuOptionViewCell.swift
//  Twitter
//
//  Created by Amay Singhal on 10/8/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class MenuOptionViewCell: UITableViewCell {

    @IBOutlet weak var menuOptionTitleLabel: UILabel!

    struct CellConstants {
        static let SelectedCellColor = AppConstants.Colors.TwitterBlueColor
        static let UnselectedCellColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        static let BorderCellColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        static let IconBaseLineToText: CGFloat = -1
        static let IconTextSize: CGFloat = 18
    }

    var menuOption: MenuOption! {
        didSet {
            updateCellUIWithOption()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addBorderToViewAtPosition(.Bottom, color: CellConstants.BorderCellColor, andThickness: 0.5)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateCellUIWithOption() {
        menuOptionTitleLabel?.textColor = menuOption.isSelected ? CellConstants.SelectedCellColor : CellConstants.UnselectedCellColor
        menuOptionTitleLabel?.attributedText = getAttributedStringForMenuOption(menuOption.title, icon: menuOption.iconType)
    }

    private func getAttributedStringForMenuOption(message: String, icon: FontasticIconType) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        if let font = UIFont(name: FontasticIcons.FontName, size: CellConstants.IconTextSize) {
            let attrs = [NSFontAttributeName : font,
                NSBaselineOffsetAttributeName: CellConstants.IconBaseLineToText]
            let iconAttrText = NSMutableAttributedString(string: icon.rawValue, attributes: attrs)
            attributedString.appendAttributedString(iconAttrText)
            message.characters.count > 0 ? attributedString.appendAttributedString(NSAttributedString(string: "  ")) : ()
        }

        attributedString.appendAttributedString(NSAttributedString(string: message))
        return attributedString
    }
}
