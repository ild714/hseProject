//
//  Script.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/6/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

struct Script: Codable {
    var did: String
    var name: String
    var roomGroup0: RoomGroop
}

struct RoomGroop: Codable {
    var rIDs: [Int]
    var dayGroup0: DayGroup
    var dayGroup1: DayGroup
}

struct DayGroup: Codable {
    var days: [Int]
    var setting0: Setting
    var setting1: Setting
}

struct Setting: Codable {
    var mute: Int
    var at_home: Int
    var time: String
    var temp: Int
    var hum: Int
    var co2: Int
    var must_use: [Int]
    var dont_use: [Int]
}
