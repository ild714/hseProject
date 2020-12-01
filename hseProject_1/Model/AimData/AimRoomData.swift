//
//  AimData.swift
//  hseProject_1
//
//  Created by Ildar on 10/22/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AimRoomData{
    
    var aimTemperature: String = ""
    var aimWet: String = ""
    var aimGas: String = ""
    
    init(result:[JSON]){
        var step = 1
        for data in result {
            if step == 1 {
                if data.rawString() == "null"{
                   self.aimTemperature = "--"
                } else {
                    self.aimTemperature = "\(data)℃"
                }
                step += 1
            } else if step == 2 {
                 if data.rawString() == "null"{
                    self.aimWet = "--"
                 } else {
                    self.aimWet = "\(data)%"
                }
                step += 1
            } else if step == 3 {
                if data.rawString() == "null"{
                   self.aimGas = "--"
                } else {
                    self.aimGas = "\(data)ppm"
                }
                step += 1
            }
        }
    }
}
