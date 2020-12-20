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

    func congigure(serviveScript: ServiceScript, number: Int) {
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

        self.soundTurnOn = serviveScript.soundOnOff
        if soundTurnOn == false {
            soundImage.setImage(UIImage(named: "mute"), for: .normal)
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
            soundTurnOn.toggle()
            delegate?.updateSound(number: index, soundOnOff: soundTurnOn)
        } else if soundTurnOn == false {
            soundImage.setImage(UIImage(named: "volume"), for: .normal)
            soundTurnOn.toggle()
            delegate?.updateSound(number: index, soundOnOff: soundTurnOn)
        }
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
            self.humidityLabel.text = "40"
            self.temperatureEdited.isUserInteractionEnabled = false
            self.humidityEdited.isUserInteractionEnabled = false
            self.temperatureLabel.text = "24"
            houseTurnOn.toggle()
            delegate?.updateHouse(number: index, houseOnOff: houseTurnOn)
        } else if houseTurnOn == false {
            houseImage.setImage(UIImage(named: "home"), for: .normal)
            temperatureImage.image = UIImage(named: "темп_б")
            humidityImage.image = UIImage(named: "влажность_б")
            self.temperatureEdited.isUserInteractionEnabled = true
            self.humidityEdited.isUserInteractionEnabled = true
            houseTurnOn.toggle()
            delegate?.updateHouse(number: index, houseOnOff: houseTurnOn)
        }
    }

    @IBOutlet weak var time: UIDatePicker!
    @IBAction func changeTime(_ sender: Any) {
        delegate?.updateTime(number: index, time: time.date)
    }

    @IBOutlet weak var temperatureEdited: UITextField!
    @IBAction func changeTemperature(_ sender: Any) {
        if let temperatureEdited = Int(self.temperatureEdited.text ?? "error") {
            if temperatureEdited < 15 || temperatureEdited > 30 {
                delegate?.showAlert(title: "Ошибка ввода температуры", message: "Ввведите снова теипературу")
                return
            } else {
                delegate?.updateTemperature(number: index, temperature: temperatureEdited)
            }
        }
    }

    @IBOutlet weak var humidityEdited: UITextField!
    @IBAction func changeHumidity(_ sender: Any) {
        if let humidityEdited = Int(self.humidityEdited.text ?? "error") {
            if humidityEdited < 30 || humidityEdited > 90 {
                delegate?.showAlert(title: "Ошибка ввода влажности", message: "Ввведите снова влажность")
                return
            } else {
                delegate?.updateHumidity(number: index, humidity: humidityEdited)
            }
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
            delegate?.updateCO2(number: index, co2: Int(co2Edited.text ?? "error") ?? 0, co2OnOff: co2TurnOn)
        } else if co2TurnOn == false {
           co2Image.setImage(UIImage(named: "со2_on"), for: .normal)
            self.co2Edited.isUserInteractionEnabled = true
            self.co2Edited.text = "800"
            co2TurnOn.toggle()
            delegate?.updateCO2(number: index, co2: Int(co2Edited.text ?? "error") ?? 0, co2OnOff: co2TurnOn)
        }
    }
    @IBAction func finsihCO2(_ sender: Any) {
        if let co2Edited = Int(self.co2Edited.text ?? "error") {
            if co2Edited < 500 || co2Edited > 1000 {
                delegate?.showAlert(title: "Некорректное значение для CO2", message: "Ввведите снова показание для СО2")
                return
            } else {
                delegate?.updateCO2(number: index, co2: co2Edited, co2OnOff: co2TurnOn)
            }
        }
    }
}

protocol CellDelagate: class {
    func updateSound(number: Int, soundOnOff: Bool)
    func updateHouse(number: Int, houseOnOff: Bool)
    func updateTime(number: Int, time: Date)
    func updateTemperature(number: Int, temperature: Int)
    func updateHumidity(number: Int, humidity: Int)
    func updateCO2(number: Int, co2: Int, co2OnOff: Bool)
    func showAlert(title: String, message: String)
}

extension ScriptServiceTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
