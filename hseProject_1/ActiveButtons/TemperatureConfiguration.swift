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

            if aimTemperatureInt <= 0 {
                return nil
            }

            aimTmperatureIntResult = aimTemperatureInt
        } else {
            if let aimTemperatureInt = Int(String(string.prefix(1))) {

                if aimTemperatureInt <= 0 {
                    return nil
                }
                aimTmperatureIntResult = aimTemperatureInt
            }
        }

        NetworkTemperatureResponse.getResponse(
            with:
                "https://vc-srvr.ru/app/ch_temp?did=40RRTM304FCdd5M80ods&rid=1&ch_temp=\(aimTmperatureIntResult)") {(result: Result<String, NetworkTemperatureError>)
            in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }

        return String(aimTmperatureIntResult - 1) + "℃"
    }

    static func plus(string: String) -> String? {
        var aimTmperatureIntResult = 0

        if let aimTemperatureInt = Int(String(string.prefix(2))) {

            if aimTemperatureInt >= 50 {
                return nil
            }

            aimTmperatureIntResult = aimTemperatureInt
        } else {
            if let aimTemperatureInt = Int(String(string.prefix(1))) {

                aimTmperatureIntResult = aimTemperatureInt
            }
        }

        NetworkTemperatureResponse.getResponse(
            with: "https://vc-srvr.ru/app/ch_temp?did=40RRTM304FCdd5M80ods&rid=1&ch_temp=\(aimTmperatureIntResult)") { (result: Result<String, NetworkTemperatureError>) in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }

        return String(aimTmperatureIntResult + 1) + "℃"
    }
}
