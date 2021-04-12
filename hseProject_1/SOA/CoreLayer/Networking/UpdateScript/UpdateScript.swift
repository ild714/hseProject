//
//  UpdateScript.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 4/4/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateScript {
    func sentUpdateDataScript(script: JSON) {
        
        guard let url = URL(string: "https://back.vc-app.ru/app/update_script") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authorizationToken(), forHTTPHeaderField: "Authorization")

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
                    }
                } else {
                    print("badData for script")
                    return
                }
            }.resume()
        }
    }
    func authorizationToken() -> String {
        guard let token = UserDefaults.standard.object(forKey: "Token") as? String else {
            return ""
        }
        return "Google" + " " + token
    }
}
