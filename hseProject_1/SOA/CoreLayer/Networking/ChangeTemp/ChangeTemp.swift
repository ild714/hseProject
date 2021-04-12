//
//  ChangeTemp.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 4/5/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChangeTemp {

    func changeTemp(rid: Int, temp: Int, completion :@escaping () -> ()) {
        guard let url = URL(string: "https://back.vc-app.ru/app/ch_temp?did=10155&rid=\(rid)&ch_temp=\(temp)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print(NetworkSensorError.errorForRequest)
                }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    print(NetworkSensorError.badData)
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

