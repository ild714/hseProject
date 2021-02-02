//
//  Model.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ModelRoomsConfigDelegate: class {
    func setup(result: [Int: String])
    func show1(error message: String)
}

class ModelRoomsConfig: ModelRoomsConfigProtocol {
    weak var delegate: ModelRoomsConfigDelegate?
    private var roomNumbersAndNames: [Int: String] = [:]
    private let roomConfigService: RoomConfigsServiceProtocol
    init(roomConfigService: RoomConfigsServiceProtocol) {
        self.roomConfigService = roomConfigService
    }
    func fetchRoomConfig() {
        self.roomConfigService.loadRoomConfigs {(result: Result<[String: JSON], NetworkError>) in
            switch result {
            case .success(let result):
                for (_, value) in result {
                    if let rid = value["rid"].int {
                        self.roomNumbersAndNames[rid] = value["r_name"].description
                    }
                }
                self.delegate?.setup(result: self.roomNumbersAndNames)
            case .failure(let error):
                self.delegate?.show1(error: error.localizedDescription)
            }
        }
    }
}
