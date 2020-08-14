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

class NetworkSensorData{
    
    private static var sensorDataDict : [String: JSON] = [:]
    
    static func getData<T>(with string: String,type sensorType: TypeOfSensor,completion:@escaping (Result<T,NetworkSensorError>) -> Void) -> Void {
        if let url = URL(string: string){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request){data, response, error in
                guard error == nil else {
                    completion(.failure(.errorForRequest))
                    return
                }
                if let data = data, let _ = response {
                    if sensorType == .current{
                        if let decodedData1 = JSON(data).dictionary {
                            DispatchQueue.main.async{
                                for (key,data) in decodedData1 {
                                    self.sensorDataDict[key] = data
                                }
                                completion(.success(self.sensorDataDict as! T))
                            }
                        }
                        else {
                            completion(.failure(.badEncodingJSON))
                            return
                        }
                    } else if sensorType == .aim {
                        if let decodedData1 = JSON(data).array {
                            DispatchQueue.main.async{
                                completion(.success(decodedData1 as! T))
                            }
                        }
                        else {
                            completion(.failure(.badEncodingJSON))
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
