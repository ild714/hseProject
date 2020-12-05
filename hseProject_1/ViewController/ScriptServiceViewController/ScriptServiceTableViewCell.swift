//
//  ScriptServiceTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/19/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptServiceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var stack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        stack.alignment = UIStackView.Alignment.center
//        stack.spacing = 3
//        stack = nil
//        stack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func congigure(serviveScript: ServiceScript, number: Int){
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.spacing = 3
        
        stack.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        self.numberLabel.text = "\(number)."
        self.temperatureLabel.text = "\(serviveScript.temperature)"
        self.humidityLabel.text = "\(serviveScript.humidity)"
        self.co2Label.text = "--"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.timeLabel.text = ("\(formatter.string(from: serviveScript.time))")
        
        if serviveScript.radiatorOn {
            let imageRadiator = UIImageView(image: UIImage(named: "radiator"))
            imageRadiator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageRadiator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageRadiator)
        }
        if serviveScript.hotFloorOn {
            let imageHotFloor = UIImageView(image: UIImage(named: "hotfloor"))
            imageHotFloor.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageHotFloor.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(UIImageView(image: UIImage(named: "hotfloor")))
        }
        if serviveScript.humidifierOn {
            let imageHumidifier = UIImageView(image: UIImage(named: "humidifier"))
            imageHumidifier.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageHumidifier.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageHumidifier)
        }
        if serviveScript.conditionerOn {
            let imageAirConditioner = UIImageView(image: UIImage(named: "air_conditioner"))
            imageAirConditioner.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageAirConditioner.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageAirConditioner)
        }
    }
}
