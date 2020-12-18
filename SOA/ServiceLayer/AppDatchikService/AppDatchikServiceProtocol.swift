//
//  AppDatchikServiceProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol AppDatchikServiceProtocol {
    func loadRoomConfigs<T>(type: TypeOfSensor, completion: @escaping (Result<T, NetworkSensorError>) -> Void)
}
