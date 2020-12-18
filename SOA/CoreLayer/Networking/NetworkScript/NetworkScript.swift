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

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(script) {

            request.httpBody = data
            URLSession.shared.dataTask(with: request) {data, _, error in
                guard error == nil else {
                    print("error with sending data")
                    return
                }

                if let data = data {
                    if let data = String(bytes: data, encoding: .utf8) {
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
