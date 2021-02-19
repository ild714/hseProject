//
//  ModelAimData.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/19/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol ModelAimDataDelegate: class {
    func setup(result: [Int: AimRoomScript])
    func show3(error message: String)
}

class ModelAimData: ModelAimDataProtocol {
    weak var delegate: ModelAimDataDelegate?
    func fetchAimData() {
        let loadAimDataNetwork = CurrentScript()
        loadAimDataNetwork.getAimDataScripts { (result: Result<[Int: AimRoomScript], NetworkSensorError>) in
            switch result {
            case .success(let result):
                self.delegate?.setup(result: result)
            case .failure(let error):
                self.delegate?.show3(error: error.localizedDescription)
            }
        }
    }
}
