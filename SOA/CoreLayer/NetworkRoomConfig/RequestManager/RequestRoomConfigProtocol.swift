//
//  NetworkRoomConfigProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol RequestRoomConfigProtocol {
    func load<Parser,T>(requestConfig: RequestConfig<Parser>, completion: @escaping (Result<T, NetworkError>) -> Void)
}

struct RequestConfig<Parser> where Parser: SwiftyParserProtocol {
    let request: RoomsRequestProtocol
    let parser: Parser
}
