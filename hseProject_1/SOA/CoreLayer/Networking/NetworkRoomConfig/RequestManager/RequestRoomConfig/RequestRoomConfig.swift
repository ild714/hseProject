//
//  Network.swift
//  hseProject_1
//
//  Created by Ildar on 8/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

enum NetworkError: Error {
    case badData
    case badEncoding
    case errorForRequest
    case badUrl
}

class RequestRoomConfig: RequestRoomConfigProtocol {

    private var typeOfRooms: [String: JSON] = [:]

    let session: URLSession?

    init(session: URLSession) {
        self.session = session
    }

    func load<Parser, T>(requestConfig: RequestConfig<Parser>, completion: @escaping (Result<T, NetworkError>) -> Void) {

        guard var urlRequest = requestConfig.request.urlRequest else {
            completion(.failure(.badUrl))
            return
        }
        if UserDefaults.standard.object(forKey: "UserEmail") as? String == "apple" {
            urlRequest.setValue(self.authorizationTokenYan(), forHTTPHeaderField: "Authorization")
        } else {
            urlRequest.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpMethod = "GET"
        let task = session?.dataTask(with: urlRequest) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.errorForRequest))
                }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let decodedRoom = requestConfig.parser.parseForRooms(data: data) {
                        print("1")
                        for (key, data) in decodedRoom {
                            if key == "did"{
                                continue
                            }
                            self.typeOfRooms[key] = data
                        }
                        if let typeOfRooms = self.typeOfRooms as? T {
                            completion(.success(typeOfRooms))
                        }
                    } else {
                        completion(.failure(.badEncoding))
                        return
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }
        }

        if let task = task {
            task.resume()
        } else {
            print("error with task")
        }
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
