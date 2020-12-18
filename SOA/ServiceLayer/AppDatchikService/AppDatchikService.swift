//
//  AppDatchikService.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

class AppDatchikService: AppDatchikServiceProtocol {
    let requstAppDatchik: RequestAppDatchikProtocol

    init(requstRoomConfig: RequestAppDatchikProtocol) {
        self.requstAppDatchik = requstRoomConfig
    }

    func loadRoomConfigs<T>(type: TypeOfSensor, completion: @escaping (Result<T, NetworkSensorError>) -> Void) {
        let requestConfig = RequestsFactory.appDatchik()
        self.makeRequst(type: type, requestConfig: RequestConfig(request: requestConfig.request, parser: requestConfig.parser), completion: completion)
    }

    private func makeRequst<T>(type: TypeOfSensor, requestConfig: RequestConfig<SwiftyParser>, completion: @escaping (Result<T, NetworkSensorError>) -> Void) {
        requstAppDatchik.load(requestConfig: requestConfig, type: type) { (result: Result<T, NetworkSensorError>) in
            completion(result)
        }
    }
}
