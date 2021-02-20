//
//  NewUser.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/20/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewUser {

    func newUser() {
        guard let url = URL(string: "https://back.vc-app.ru/auth/register") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) {data, _, error in
            guard error == nil else {
                return
            }
            if let data = data {
            } else {
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
