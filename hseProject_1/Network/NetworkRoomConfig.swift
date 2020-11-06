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

class NetworkRoomConfig {
    
    private static var typeOfRooms : [String: JSON] = [:]
    
    static func urlSession<T>(with string: String,completion: @escaping (Result<T, NetworkError>) -> Void) -> Void {

        guard let url = URL(string: string) else {
            completion(.failure(.badUrl))
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request){data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async{
                    completion(.failure(.errorForRequest))
                }
                return
            }
            
            if let data = data, let _ = response {
                DispatchQueue.main.async{
                    if let decodedRoom = JSON(data).dictionary {
                        for (key,data) in decodedRoom{
                            if key == "did"{
                                continue
                            }
                            typeOfRooms[key] = data
                        }
                        completion(.success(typeOfRooms as! T))
                    } else {
                        completion(.failure(.badEncoding))
                        return
                    }
                }
            } else {
                DispatchQueue.main.async{
                    completion(.failure(.badData))
                }
                return
            }
        }.resume()
        
    }
    
}

