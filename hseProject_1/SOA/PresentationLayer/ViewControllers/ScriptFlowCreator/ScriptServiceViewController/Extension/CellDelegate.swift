//
//  CellDelegate.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/20/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

extension ScriptServiceViewController: CellDelagate {
    func updateCO2(number: Int, co2: Int, co2OnOff: Bool) {
        self.serviceScripts[number].co2 = co2
        self.serviceScripts[number].co2OnOff = co2OnOff
        tableView.reloadData()
    }

    func updateTime(number: Int, time: Date) {
        self.serviceScripts[number].time = time
        print(serviceScripts[number].time)
        tableView.reloadData()
    }

    func updateTemperature(number: Int, temperature: Int) {
        self.serviceScripts[number].temperature = temperature
        tableView.reloadData()
    }

    func updateHumidity(number: Int, humidity: Int) {
        self.serviceScripts[number].humidity = humidity
        tableView.reloadData()
    }

    func updateHouse(number: Int, houseOnOff: Bool) {
        if self.serviceScripts[number].hotFloorOn {
            self.serviceScripts[number].temperature = 24
            self.serviceScripts[number].humidity = 40
            self.serviceScripts[number].houseOnOff = houseOnOff
            tableView.reloadData()
        } else {
            self.serviceScripts[number].houseOnOff = houseOnOff
            tableView.reloadData()
        }
    }
    func updateSound(number: Int, soundOnOff: Bool) {
        self.serviceScripts[number].soundOnOff = soundOnOff
        tableView.reloadData()
    }
    func showAlert(title: String, message: String) {
        let vcAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(vcAlert, animated: true)
    }
}
