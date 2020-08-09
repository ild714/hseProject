//
//  Network.swift
//  hseProject_1
//
//  Created by Ildar on 8/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case badData
    case badEncoding
    case erroForRequest
}

class NetworkRoomConfig {
    
    static func urlRequest(string: String) -> URLRequest? {
        guard let url = URL(string: string) else {
            print("badURL")
            return nil
        }
        let request = URLRequest(url: url)
        
        return request
    }
    
    static func urlSession<T:Codable>(with request: URLRequest,completion: @escaping (Result<T, NetworkError>) -> Void) -> Void {

        URLSession.shared.dataTask(with: request){data, response, error in
            
            guard error == nil else {
                completion(.failure(.erroForRequest))
                return
            }
            
            if let data = data, let _ = response {
                DispatchQueue.main.async{
                    if let decodedRoom: T = parse(data) {
                        completion(.success(decodedRoom))
                    } else {
                        completion(.failure(.badEncoding))
                        return
                    }
                }
            } else {
                completion(.failure(.badData))
                return
            }
        }.resume()
        
    }
    
    static func parse<T:Codable>(_ data: Data) -> T? {
        if let decodedData = try? JSONDecoder().decode(T.self, from: data){
            return decodedData
        } else {
            return nil
        }
    }
}

