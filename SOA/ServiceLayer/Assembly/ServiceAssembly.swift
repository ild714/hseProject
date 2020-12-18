//
//  ServiceAssembly.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol ServiceAssemblyProtocol {
    var roomsConfigService: RoomConfigsServiceProtocol { get }
    var appDatchikService: AppDatchikServiceProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol

    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }

    lazy var roomsConfigService: RoomConfigsServiceProtocol = RoomConfigsService(requstRoomConfig: self.coreAssembly.requestRoomsConfigs )
    lazy var appDatchikService: AppDatchikServiceProtocol = AppDatchikService(requstRoomConfig: self.coreAssembly.requestAppDatchik)
}
