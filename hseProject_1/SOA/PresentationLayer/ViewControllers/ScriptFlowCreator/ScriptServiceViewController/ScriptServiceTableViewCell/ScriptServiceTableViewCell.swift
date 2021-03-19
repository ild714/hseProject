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
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var viewService: ViewCustomClass!
    @IBOutlet weak var co2Image: UIButton!
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        temperatureEdited.delegate = self
        humidityEdited.delegate = self
        co2Edited.delegate = self
    }

    @IBOutlet weak var customView: ViewCustomClass!
    func congigure(serviveScript: ServiceScript, number: Int, turnOnColor: Bool) {
        if turnOnColor {
            customView.backgroundColor = UIColor(redS: 212, greenS: 212, blueS: 212)
        } else {
            customView.backgroundColor = .white
        }
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.spacing = 3

        stack.subviews.forEach { (view) in
            view.removeFromSuperview()
        }

        self.numberLabel.text = "\(number)."
        self.temperatureLabel.text = "\(serviveScript.temperature)"
        self.humidityLabel.text = "\(serviveScript.humidity)"
        if serviveScript.co2 == 0 {
            self.co2Label.text = "--"
        } else {
            self.co2Label.text = "\(serviveScript.co2)"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.timeLabel.text = ("\(formatter.string(from: serviveScript.time))")

        if serviveScript.radiatorOn {
            let imageRadiator = UIImageView(image: UIImage(named: "radiator"))
            imageRadiator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageRadiator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageRadiator)
        } else {
            let imageRadiator = UIImageView(image: UIImage(named: "not_radiator"))
            imageRadiator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageRadiator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageRadiator)
        }
        if serviveScript.hotFloorOn {
            let imageHotFloor = UIImageView(image: UIImage(named: "hotfloor"))
            imageHotFloor.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageHotFloor.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageHotFloor)
        } else {
            let imageHotFloor = UIImageView(image: UIImage(named: "not_hotfloor"))
            imageHotFloor.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageHotFloor.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageHotFloor)
        }
        if serviveScript.humidifierOn {
            let imageHumidifier = UIImageView(image: UIImage(named: "humidifier"))
            imageHumidifier.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageHumidifier.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageHumidifier)
        } else {
            let imageHotFloor = UIImageView(image: UIImage(named: "not_humidifier"))
            imageHotFloor.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageHotFloor.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageHotFloor)
        }
        if serviveScript.conditionerOn {
            let imageAirConditioner = UIImageView(image: UIImage(named: "air_conditioner"))
            imageAirConditioner.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageAirConditioner.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageAirConditioner)
        } else {
            let imageAirConditioner = UIImageView(image: UIImage(named: "not_air_conditioner"))
            imageAirConditioner.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageAirConditioner.widthAnchor.constraint(equalToConstant: 25).isActive = true
            stack.addArrangedSubview(imageAirConditioner)
        }

        self.soundTurnOn = serviveScript.soundOnOff
        if soundTurnOn == false {
            soundImage.setImage(UIImage(named: "mute"), for: .normal)
            soundImage.isEnabled = false
        }
        self.houseTurnOn = serviveScript.houseOnOff
        if houseTurnOn == false {
            self.humidityLabel.text = "40"
            self.temperatureLabel.text = "24"
        }
        self.time.date = serviveScript.time
        if serviveScript.co2 == 0 {
            self.co2Edited.text = "--"
            self.co2TurnOn = serviveScript.co2OnOff
        } else {
            self.co2Edited.text = "\(serviveScript.co2)"
            self.co2TurnOn = serviveScript.co2OnOff
        }
    }

    weak var delegate: CellDelagate?

    @IBOutlet weak var soundImage: UIButton!
    var soundTurnOn = true
    @IBAction func soundTurnOnOff(_ sender: Any) {
        if soundTurnOn == true {
            soundImage.setImage(UIImage(named: "mute"), for: .normal)

        } else if soundTurnOn == false {
            soundImage.setImage(UIImage(named: "volume"), for: .normal)
        }
        soundTurnOn.toggle()
    }

    @IBOutlet weak var houseImage: UIButton!
    @IBOutlet weak var temperatureImage: UIImageView!
    @IBOutlet weak var humidityImage: UIImageView!
    var houseTurnOn = true
    @IBAction func houseOnOff(_ sender: Any) {
        if houseTurnOn == true {
            houseImage.setImage(UIImage(named: "not_home"), for: .normal)
            temperatureImage.image = UIImage(named: "темп_min")
            humidityImage.image = UIImage(named: "влажность_max")
            humidityEdited.text = "40"
            self.temperatureEdited.isUserInteractionEnabled = false
            self.humidityEdited.isUserInteractionEnabled = false
            temperatureEdited.text = "24"
        } else if houseTurnOn == false {
            houseImage.setImage(UIImage(named: "home"), for: .normal)
            temperatureImage.image = UIImage(named: "темп_б")
            humidityImage.image = UIImage(named: "влажность_б")
            self.temperatureEdited.isUserInteractionEnabled = true
            self.humidityEdited.isUserInteractionEnabled = true
        }
        houseTurnOn.toggle()
    }

    @IBOutlet weak var time: UIDatePicker!
    @IBAction func changeTime(_ sender: Any) {
    }

    @IBOutlet weak var temperatureEdited: UITextField!
    var intTemperature = 24
    @IBAction func changeTemperature(_ sender: Any) {
        if let temperatureEdited = Int(self.temperatureEdited.text ?? "error") {
            if temperatureEdited < 15 || temperatureEdited > 30 {
                delegate?.showAlert(title: "Ошибка ввода температуры", message: "Ввведите снова теипературу")
                return
            } else {
                intTemperature = temperatureEdited
            }
        } else {
            delegate?.showAlert(title: "Ошибка ввода температуры", message: "Ввведите снова температуру")
        }
    }

    @IBOutlet weak var humidityEdited: UITextField!
    var intHumidity = 40
    @IBAction func changeHumidity(_ sender: Any) {
        if let humidityEdited = Int(self.humidityEdited.text ?? "error") {
            if humidityEdited < 30 || humidityEdited > 90 {
                delegate?.showAlert(title: "Ошибка ввода влажности", message: "Ввведите снова влажность")
                return
            } else {
                intHumidity = humidityEdited
            }
        } else {
            delegate?.showAlert(title: "Ошибка ввода влажности", message: "Ввведите снова влажность")
        }
    }

    var co2TurnOn = true
    @IBOutlet weak var co2Edited: UITextField!
    @IBAction func changeCo2(_ sender: Any) {
        if co2TurnOn == true {
          co2Image.setImage(UIImage(named: "со2_off"), for: .normal)
            self.co2Edited.text = "--"
            self.co2Edited.isUserInteractionEnabled = false
            co2TurnOn.toggle()
        } else if co2TurnOn == false {
           co2Image.setImage(UIImage(named: "со2_on"), for: .normal)
            self.co2Edited.isUserInteractionEnabled = true
            self.co2Edited.text = "800"
            co2TurnOn.toggle()
        }
    }
    var intCO2 = 800
    @IBAction func finsihCO2(_ sender: Any) {
        if let co2Edited = Int(self.co2Edited.text ?? "error") {
            if co2Edited < 500 || co2Edited > 1000 {
                delegate?.showAlert(title: "Некорректное значение для CO2", message: "Ввведите снова показание для СО2")
                return
            } else {
                intCO2 = co2Edited
            }
        }
    }
    @IBAction func savePressed(_ sender: Any) {
        delegate?.update(number: index, soundOnOff: soundTurnOn, houseOnOff: houseTurnOn, time: time.date, temperature: intTemperature, humidity: intHumidity, co2: intCO2, co2OnOff: co2TurnOn)
    }
    @IBAction func closePressed(_ sender: Any) {
        delegate?.close(index: index)
    }
}

protocol CellDelagate: class {
    func updateCell()
    func close(index: Int)
    func showAlert(title: String, message: String)
    func update(number: Int, soundOnOff: Bool, houseOnOff: Bool, time: Date, temperature: Int, humidity: Int, co2: Int, co2OnOff: Bool)
}

extension ScriptServiceTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
