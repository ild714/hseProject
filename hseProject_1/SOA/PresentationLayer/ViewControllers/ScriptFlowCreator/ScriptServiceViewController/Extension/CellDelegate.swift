//
//  CellDelegate.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/20/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

extension ScriptServiceViewController: CellDelagate {
    func close(index: Int) {
        closeCell(index: index)
    }
    func updateCell() {
        tableView.reloadData()
    }
    func update(number: Int,
                soundOnOff: Bool,
                houseOnOff: Bool,
                time: Date,
                temperature: Int,
                humidity: Int,
                co2: Int,
                co2OnOff: Bool) {
        self.serviceScripts[number].co2 = co2
        self.serviceScripts[number].co2OnOff = co2OnOff

        self.serviceScripts[number].time = time
        print(serviceScripts[number].time)
        self.serviceScripts[number].temperature = temperature
        self.serviceScripts[number].humidity = humidity

        if self.serviceScripts[number].hotFloorOn {
            self.serviceScripts[number].houseOnOff = houseOnOff
        } else {
            self.serviceScripts[number].houseOnOff = houseOnOff
        }

        self.serviceScripts[number].soundOnOff = soundOnOff
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            group.leave()
        }
        group.notify(queue: .main) {
            self.close(index: number)
        }
    }

    func showAlert(title: String, message: String) {
        let vcAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(vcAlert, animated: true)
    }
}
