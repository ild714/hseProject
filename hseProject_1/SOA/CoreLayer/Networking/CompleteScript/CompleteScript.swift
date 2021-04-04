//
//  CompleteScript.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 4/4/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class CompleteScript {

//    private var currentScripts: [Int: AimRoomScript] = [:]

    func getCompleteScript(id: Int,completion: @escaping (Result<JSON, NetworkSensorError>) -> Void) {
        guard let url = URL(string: "https://back.vc-app.ru/dev/script?did=10155&sc_id=\(id)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.errorForRequest))
                }
                return
            }
            if let data = data {
//                if let decodedData = JSON(data) {
                print(JSON(data).dictionary)
//                    for (key, data) in decodedData {
//                        self.currentScripts[data["rid"].intValue] = AimRoomScript(
//                            temp: data["temp"].intValue,
//                            co2: data["co2"].intValue,
//                            humidity: data["humidity"].intValue,
//                            ch_temp: nil,
//                            flow: data["flow"].intValue)
//                    }
                DispatchQueue.main.async {
                    completion(.success(JSON(data)))
                }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(.failure(.badEncodingJSON))
//                    }
//                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
            }
        }.resume()
    }
    func authorizationToken() -> String {
        guard let token = UserDefaults.standard.object(forKey: "Token") as? String else {
            return ""
        }
        return "Google" + " " + token
    }
}
