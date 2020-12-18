//
//  Model.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ModelProtocol: class {
    func fetchRoomConfig()
    var delegate: ModelDelegate? {get set}
}

protocol ModelDelegate: class {
    func setup(result: [Int: String])
    func show(error message: String)
}

class ModelRoomsConfig: ModelProtocol {
    weak var delegate: ModelDelegate?
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
                    self.roomNumbersAndNames[value["rid"].int ?? 0] = value["r_name"].description
                }
                self.delegate?.setup(result: self.roomNumbersAndNames)
            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.show(error: error.localizedDescription)
            }
        }
    }
}
