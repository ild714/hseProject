//
//  NetworkSensorData.swift
//  hseProject_1
//
//  Created by Ildar on 8/11/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

enum NetworkSensorError: Error {
    case badData
    case badEncodingJSON
    case errorForRequest
    case badUrl
}

enum TypeOfSensor {
    case current
    case aim
}

class RequestAppDatchik: RequestAppDatchikProtocol {

    let session: URLSession?

    init(session: URLSession) {
        self.session = session
    }

    private var sensorDataDict: [String: JSON] = [:]

    func load<Parser, T>(requestConfig: RequestConfig<Parser>, type sensorType: TypeOfSensor, completion: @escaping (Result<T, NetworkSensorError>) -> Void) where Parser: SwiftyParserProtocol {

        guard var urlRequest = requestConfig.request.urlRequest else {
            completion(.failure(.badUrl))
            return
        }
        urlRequest.setValue(self.authorizationToken(), forHTTPHeaderField: "Authorization")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"

        let task = session?.dataTask(with: urlRequest) {data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.errorForRequest))
                }
                return
            }
            if let data = data {
                if sensorType == .current {
                    if let decodedData1 = JSON(data).dictionary {
                        DispatchQueue.main.async {
                            for (key, data) in decodedData1 {
                                self.sensorDataDict[key] = data
                            }
                            if let sensorDataDict = self.sensorDataDict as? T {
                                completion(.success(sensorDataDict))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(.badEncodingJSON))
                        }
                        return
                    }
                } else if sensorType == .aim {
                    if let decodedData1 = JSON(data).array {
                        DispatchQueue.main.async {
                            if let decodedData1 = decodedData1 as? T {
                                completion(.success(decodedData1))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(.badEncodingJSON))
                        }
                        return
                    }
                }
            } else {
                completion(.failure(.badData))
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
        return "Yandex" + " " + "AgAAAAAaGAgvAAa-ictSVhJT0UkruSzpJe4JCos"
    }
}
