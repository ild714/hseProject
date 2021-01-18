//
//  CurrentDaysTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/17/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CurrentDaysTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDays: UILabel!
    
    func configure(days: String) {
        self.labelDays.font = UIFont(name: "Arial", size: 21)
        self.labelDays.text = days
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
