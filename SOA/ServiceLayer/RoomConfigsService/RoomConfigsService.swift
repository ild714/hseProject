//
//  RoomConfigsService.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

class RoomConfigsService: RoomConfigsServiceProtocol {

    let requstRoomConfig: RequestRoomConfigProtocol

    init(requstRoomConfig: RequestRoomConfigProtocol) {
        self.requstRoomConfig = requstRoomConfig
    }

    func loadRoomConfigs<T>(completion: @escaping (Result<T, NetworkError>) -> Void) {

        let requestConfig = RequestsFactory.newRoomsConfig()
        self.makeRequst(requestConfig: RequestConfig(request: requestConfig.request, parser: requestConfig.parser), completion: completion)
    }

    private func makeRequst<T>(requestConfig: RequestConfig<SwiftyParser>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        requstRoomConfig.load(requestConfig: requestConfig) { (result: Result<T, NetworkError>) in
            completion(result)
        }
    }
}
