//
//  ModelsProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ModelRoomsConfigProtocol: class {
    func fetchRoomConfig()
    var delegate: ModelRoomsConfigDelegate? { get set }
}

protocol ModelRoomsConfigDelegate: class {
    func setup(result: [Int: String])
    func show1(error message: String)
}

protocol ModelAppDatchikProtocol {
    func fetchAppDatchik(type: TypeOfSensor, completion: @escaping ([String: JSON]) -> Void)
    var delegate: ModelAppDatchikDelegate? { get set }
}

protocol ModelAppDatchikDelegate: class {
    func show2(error message: String)
}
