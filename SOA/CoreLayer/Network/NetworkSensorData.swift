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

class NetworkSensorData {

    private static var sensorDataDict: [String: JSON] = [:]

    static func getData<T>(with string: String, type sensorType: TypeOfSensor, completion:@escaping (Result<T, NetworkSensorError>) -> Void) {
        if let url = URL(string: string) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) {data, _ , error in
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
                                if let sensorDataDict = sensorDataDict as? T {
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
            }.resume()
        } else {
            completion(.failure(.badUrl))
            return
        }
    }
}
