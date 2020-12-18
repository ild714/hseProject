//
//  RoomsRequest.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

class Requests: RequestProtocol {
//    private var url: String = "https://vc-srvr.ru/site/rm_config?did=40RRTM304FCdd5M80ods"

    fileprivate var command: String {
        return ""
    }
    private var baseUrl: String = "https://vc-srvr.ru"
    var urlRequest: URLRequest? {
        if let url = URL(string: baseUrl + command) {
            return URLRequest(url: url)
        }

        return nil
    }
}

class RoomConfigRequest: Requests {
    override var command: String { return "/site/rm_config?did=40RRTM304FCdd5M80ods"}
}

class AppDatchikRequest: Requests {
    override var command: String { return "/app/datchik?did=40RRTM304FCdd5M80ods"}
}
