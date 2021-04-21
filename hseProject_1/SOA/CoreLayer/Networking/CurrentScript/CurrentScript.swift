//
//  CurrentScript.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/19/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class CurrentScript {

    private var currentScripts: [Int: AimRoomScript] = [:]

    func getAimDataScripts(completion: @escaping (Result<[Int: AimRoomScript], NetworkSensorError>) -> Void) {
        guard let url = URL(string: "https://back.vc-app.ru/app/script_cur?did=10155") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if UserDefaults.standard.object(forKey: "UserEmail") as? String == "apple" {
            request.setValue(self.authorizationTokenYan(), forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")
        }
        print("cuurent script")
        print(request.description)

        URLSession.shared.dataTask(with: request) {data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.errorForRequest))
                }
                return
            }
            if let data = data {
                if let decodedData = JSON(data).dictionary {
                    for (_, data) in decodedData {
                        self.currentScripts[data["rid"].intValue] = AimRoomScript(
                            temp: data["temp"].intValue,
                            co2: data["co2"].intValue,
                            humidity: data["humidity"].intValue,
                            ch_temp: data["ch_temp"].intValue,
                            flow: data["flow"].intValue)
                        print("current scripts data")
                        print(self.currentScripts)
                    }
                    DispatchQueue.main.async {
                        completion(.success(self.currentScripts))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(.badEncodingJSON))
                    }
                }
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
    func authorizationTokenYan() -> String {
        guard let token = UserDefaults.standard.object(forKey: "Token") as? String else {
            return ""
        }
        return "Yandex" + " " + "AgAAAAAaGAgvAAa-ictSVhJT0UkruSzpJe4JCos"
    }
}
