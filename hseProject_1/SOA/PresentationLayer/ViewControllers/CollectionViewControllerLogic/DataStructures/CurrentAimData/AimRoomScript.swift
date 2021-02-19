//
//  CurrentAimData.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/19/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

struct AimRoomScript: Codable {
    var temp: Int
    var co2: Int
    var humidity: Int
    var ch_temp: Int?
    var flow: Int
}
