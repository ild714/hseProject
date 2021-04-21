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

    func getCompleteScript(id: Int, completion: @escaping (Result<JSON, NetworkSensorError>) -> Void) {
        guard let url = URL(string: "https://back.vc-app.ru/dev/script?did=10155&sc_id=\(id)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if UserDefaults.standard.object(forKey: "UserEmail") as? String == "apple" {
            request.setValue(self.authorizationTokenYan(), forHTTPHeaderField: "Authorization")
        } else {
            request.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) {data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.errorForRequest))
                }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    completion(.success(JSON(data)))
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
