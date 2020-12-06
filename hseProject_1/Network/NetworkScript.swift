//
//  NetworkScript.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/6/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class NetworkScript {
    
    func sentDataScript(script: ScriptCreator) {
        guard let url = URL(string: "https://back.vc-app.ru/test") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        let setting = Setting(mute: 0, at_home: 1, time: "21:20", temp: 21, hum: 55, co2: 700, must_use: [], dont_use: [])
//        let dayGroup1 = DayGroup(days: [1,2,3], setting0: setting, setting1: setting)
//        let dayGroup2 = DayGroup(days: [1,2], setting0: setting, setting1: setting)
//        let roomGroup = RoomGroop(rIDs: [47,48], dayGroup0: dayGroup1, dayGroup1: dayGroup2)
//        let script = Script(did: "10153", name: "test", roomGroup0: roomGroup)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(script) {
            
//            print(String(bytes: data, encoding: .utf8))
            
            request.httpBody = data
            URLSession.shared.dataTask(with: request) {data, response, error in
                guard error == nil else {
                    print("error with sending data")
                    return
                }

                if let data = data, let _ = response {
                    if let data = String(bytes: data, encoding: .utf8){
                        print(data)
                    }
                } else {
                    print("badData for script")
                    return
                }
            }.resume()
        }
    }
}
