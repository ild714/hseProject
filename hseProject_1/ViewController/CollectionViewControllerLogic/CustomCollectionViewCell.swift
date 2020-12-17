//
//  CustomCollectionViewCell.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var wet: UILabel!
    @IBOutlet weak var gas: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
    }

    override func awakeFromNib() {
        ActivityIndicator.animateActivityLabel(labels: [LabelActivity(label: roomNameLabel), LabelActivity(label: wet), LabelActivity(label: gas), LabelActivity(label: temperature)])
    }

//    func loadViewFromNib() -> UIView {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        return view
//    }

    func configure(currentRoomText: String, currentRoom: CurrentRoomData) {

        roomNameLabel.text = currentRoomText
        temperature.text = currentRoom.cellTemperature
        wet.text = currentRoom.cellWet
        gas.text = currentRoom.cellGas

        ActivityIndicator.stopAnimating(views: [wet, gas, temperature, roomNameLabel])
    }

}
