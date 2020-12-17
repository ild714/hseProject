//
//  ScriptCreater.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/6/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

struct ScriptCreator: Codable {
    var did: String
    var name: String
    var roomGroup0: RoomGroopCreator?
}

struct RoomGroopCreator: Codable {
    var rIDs: [Int]
    var dayGroup0: DayGroupCreator?
    var dayGroup1: DayGroupCreator?
}

struct DayGroupCreator: Codable {
    var days: [Int]
    var setting0: SettingCreator?
    var setting1: SettingCreator?
}

struct SettingCreator: Codable {
    var mute: Int
    var at_home: Int
    var time: String
    var temp: Int
    var hum: Int
    var co2: Int
    var must_use: [Int]
    var dont_use: [Int]
}
