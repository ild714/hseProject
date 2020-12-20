//
//  CoreAssembly.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var requestRoomsConfigs: RequestRoomConfigProtocol { get }
    var requestAppDatchik: RequestAppDatchikProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    var requestRoomsConfigs: RequestRoomConfigProtocol = RequestRoomConfig(session: URLSession.shared)
    var requestAppDatchik: RequestAppDatchikProtocol = RequestAppDatchik(session: URLSession.shared)
}
