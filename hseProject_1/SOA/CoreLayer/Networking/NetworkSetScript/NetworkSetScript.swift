//
//  NetworkSetScript.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/2/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class NetworkSetScript {
    func sentDataScript(scId: Int) {
        guard let url = URL(string: "https://\(Bundle.main.infoDictionary?["SET_SCRIPT_ID"] as? String ?? "")?did=10155&sc_id=\(scId)") else {
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
                print("error with sending data")
                return
            }
            if let data = data {
                if let data = String(bytes: data, encoding: .utf8) {
                    print("!")
                    print(data)
                    print("!")
                }
            } else {
                print("badData for script")
                return
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
