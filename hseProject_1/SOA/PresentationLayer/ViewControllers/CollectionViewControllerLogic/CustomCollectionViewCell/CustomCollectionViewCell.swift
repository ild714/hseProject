//
//  CustomCollectionViewCell.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewSelf: UIView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var wet: UILabel!
    @IBOutlet weak var gas: UILabel!
    @IBOutlet weak var animation: UIActivityIndicatorView!
    
    @IBOutlet weak var tempImage: UIImageView!
    @IBOutlet weak var wetImage: UIImageView!
    @IBOutlet weak var co2Image: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
    }

    override func awakeFromNib() {
        animation.startAnimating()
//        ActivityIndicator.animateActivityLabel(labels: [LabelActivity(label: roomNameLabel), LabelActivity(label: wet), LabelActivity(label: gas), LabelActivity(label: temperature)])
//        ActivityIndicator.animateView(view: viewSelf)
    }

    func configure(currentRoomText: String, currentRoom: CurrentRoomData) {
        if currentRoom.cellWet.isEmpty == true {
            tempImage.isHidden = true
            wetImage.isHidden = true
            co2Image.isHidden = true
        } else {
            animation.stopAnimating()
            animation.isHidden = true
            
            roomNameLabel.text = currentRoomText
            temperature.text = currentRoom.cellTemperature
            wet.text = currentRoom.cellWet
            gas.text = currentRoom.cellGas
            
            tempImage.isHidden = false
            wetImage.isHidden = false
            co2Image.isHidden = false
        }
//        ActivityIndicator.stopAnimating(views: [wet, gas, temperature, roomNameLabel])
    }

}
