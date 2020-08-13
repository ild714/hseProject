//
//  TemperatureConfiguration.swift
//  hseProject_1
//
//  Created by Ildar on 8/13/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class TemperatureConfig {
    static func minus(string: String) -> String? {
        
        if let aimTmperatureInt = Int(String(string.prefix(2))) {
            
            if aimTmperatureInt <= 0 {
                return nil
            }

            return String(aimTmperatureInt - 1) + "℃"
        } else {
            if let aimTmperatureInt = Int(String(string.prefix(1))) {
                
                if aimTmperatureInt <= 0 {
                    return nil
                }
                return String(aimTmperatureInt - 1) + "℃"
            }
        }
        return nil
    }
    
    static func plus(string: String) -> String? {
        
        if let aimTmperatureInt = Int(String(string.prefix(2))) {
            
            if aimTmperatureInt >= 50 {
                return nil
            }
            return String(aimTmperatureInt + 1) + "℃"
        } else {
            if let aimTmperatureInt = Int(String(string.prefix(1))) {
                return String(aimTmperatureInt + 1) + "℃"
            }
        }
        return nil
    }
}
