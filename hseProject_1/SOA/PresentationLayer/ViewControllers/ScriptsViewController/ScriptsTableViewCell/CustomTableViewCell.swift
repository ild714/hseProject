//
//  CustomTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var scriptLabel: UILabel!
    @IBOutlet weak var markImage: UIImageView!
    @IBOutlet weak var backgroundCustomView: ViewCustomClass!
    let gradient: CAGradientLayer = CAGradientLayer()

    func configure(scriptText: String, mark: Bool) {

        self.scriptLabel.text = scriptText

        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        if mark {
            self.markImage.image = UIImage(named: "full_radio")

            gradient.colors = [UIColor.init(rgb: 0x5b80ea).cgColor, UIColor.init(rgb: 0x37b5dd).cgColor]
            self.backgroundCustomView.layer.insertSublayer(gradient, at: 0)
            self.scriptLabel.textColor = .white
        } else {
            self.markImage.image = UIImage(named: "empty_radio")
            self.gradient.removeFromSuperlayer()
            self.scriptLabel.textColor = .black
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        gradient.frame = contentView.frame
    }
}
