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
    var modOfCurrentTemperature: String = ""
    var currentWet: String = ""
    var modOfCurrentWet: String = ""
    var currentGas: String = ""
    var ppm: String = ""
    var peopleInRoom: String = ""

    var cellTemperature: String = ""
    var cellWet: String = ""
    var cellGas: String = ""

    init(result: [String: JSON], curentRoom: Int) {
        if let currentRoomData = result["\(curentRoom)"] {
            for data in currentRoomData {

                if data.0 == "1"{
//                    self.currentTemperature = "\(Int(floor(data.1.doubleValue)))."
                    self.currentTemperature = "\(data.1.doubleValue)℃"
                    self.cellTemperature = "\(data.1.doubleValue)℃"
//                    self.modOfCurrentTemperature = "\(String(String(data.1.doubleValue)[3...4]))℃"
                } else if data.0 == "3"{
//                    self.currentWet =  "\(Int(floor(data.1.doubleValue)))."
                    self.currentWet = "\(data.1.doubleValue)%"
                    self.cellWet = "\(data.1.doubleValue)%"
//                    self.modOfCurrentWet = "\(String(String(data.1.doubleValue)[3...4]))%"
                } else if data.0 == "4"{
                    self.currentGas = "\(data.1)ppm"
                    self.cellGas = "\(data.1)ppm"
                    self.ppm = "ppm"
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
