//
//  RoomConfigsProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol RoomConfigsServiceProtocol {
    func loadRoomConfigs<T>(completion: @escaping (Result<T, NetworkError>) -> Void)
}
