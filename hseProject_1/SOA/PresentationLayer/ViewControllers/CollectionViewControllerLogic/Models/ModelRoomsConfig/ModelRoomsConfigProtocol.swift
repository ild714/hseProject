//
//  ModelsProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol ModelRoomsConfigProtocol: class {
    func fetchRoomConfig()
    var delegate: ModelRoomsConfigDelegate? { get set }
}
