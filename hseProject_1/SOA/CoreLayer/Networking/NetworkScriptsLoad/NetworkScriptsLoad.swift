//
//  NetworkScriptsLoad.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/11/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class NetworkScriptLoad {

    private var scriptsDataDict: [String: JSON] = [:]

    func getDataScripts<T>(completion: @escaping (Result<T, NetworkSensorError>) -> Void) {
        guard let url = URL(string: "https://back.vc-app.ru/app/get_scripts?did=10155") else {
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
                if let decodedData = JSON(data).dictionary {
                        for (key, data) in decodedData {
                            self.scriptsDataDict[key] = data
                        }
                        if let scriptsDataDict = self.scriptsDataDict as? T {
                            DispatchQueue.main.async {
                                completion(.success(scriptsDataDict))
                            }
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
}
