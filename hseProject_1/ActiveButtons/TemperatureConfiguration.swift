//
//  TemperatureConfiguration.swift
//  hseProject_1
//
//  Created by Ildar on 8/13/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class TemperatureConfig {
    static func minus(string: String) -> String? {

        var aimTmperatureIntResult = 0

        if let aimTemperatureInt = Int(String(string.prefix(2))) {
            if aimTemperatureInt <= 15 {
                return nil
            }
            aimTmperatureIntResult = aimTemperatureInt
        } else {
            if let aimTemperatureInt = Int(String(string.prefix(1))) {
                if aimTemperatureInt <= 15 {
                    return nil
                }
                aimTmperatureIntResult = aimTemperatureInt
            }
        }
        return String(aimTmperatureIntResult - 1) + "℃"
    }

    static func plus(string: String) -> String? {
        var aimTmperatureIntResult = 0

        if let aimTemperatureInt = Int(String(string.prefix(2))) {
            if aimTemperatureInt >= 30 {
                return nil
            }
            aimTmperatureIntResult = aimTemperatureInt
        } else {
            if let aimTemperatureInt = Int(String(string.prefix(1))) {
                aimTmperatureIntResult = aimTemperatureInt
            }
        }
        return String(aimTmperatureIntResult + 1) + "℃"
    }
}
