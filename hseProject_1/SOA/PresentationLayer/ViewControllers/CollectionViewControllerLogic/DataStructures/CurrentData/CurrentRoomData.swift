//
//  CurrentData.swift
//  hseProject_1
//
//  Created by Ildar on 10/22/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CurrentRoomData {

    var currentTemperature: String = ""
    var currentWet: String = ""
    var currentGas: String = ""
    var peopleInRoom: String = ""

    var cellTemperature: String = ""
    var cellWet: String = ""
    var cellGas: String = ""

    init(result: [String: JSON], curentRoom: Int) {
        if let currentRoomData = result["\(curentRoom)"] {
            for data in currentRoomData {

                if data.0 == "1"{
                    self.currentTemperature = "\(data.1.doubleValue)℃"
                    self.cellTemperature = "\(data.1.doubleValue)℃"
                } else if data.0 == "4"{
                    self.currentWet = "\(data.1.doubleValue)%"
                    self.cellWet = "\(data.1.doubleValue)%"
                } else if data.0 == "3"{
                    self.currentGas = "\(data.1)ppm"
                    self.cellGas = "\(data.1)ppm"
                } else if data.0 == "5" {
                    if let people = data.1.string {
                        self.peopleInRoom = people
                    } else {
                        self.peopleInRoom = "0"
                    }
                }
            }
        }
    }
}
