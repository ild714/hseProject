//
//  Model.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

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
                    self.roomNumbersAndNames[value["rid"].int ?? 0] = value["r_name"].description
                }
                print("test")
                print(self.roomNumbersAndNames)
                self.delegate?.setup(result: self.roomNumbersAndNames)
            case .failure(let error):
                print(error)
                self.delegate?.show1(error: error.localizedDescription)
            }
        }
    }
}
