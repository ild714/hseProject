//
//  RoomsRequest.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

class RoomsRequest: RoomsRequestProtocol {
    private var url: String = "https://vc-srvr.ru/site/rm_config?did=40RRTM304FCdd5M80ods"

    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }

        return nil
    }
}
