//
//  RoomsRequest.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

class Requests: RequestProtocol {

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
    override var command: String { return Bundle.main.infoDictionary?["ROOM_CONFIG"] as? String ?? ""}
}

class AppDatchikRequest: Requests {
    override var command: String { return Bundle.main.infoDictionary?["DATCHIK"] as? String ?? ""}
}
