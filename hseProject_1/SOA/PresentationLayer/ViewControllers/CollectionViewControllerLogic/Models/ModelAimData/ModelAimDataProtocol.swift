//
//  ModelAimDataProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/19/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol ModelAimDataProtocol: class {
    func fetchAimData()
    var delegate: ModelAimDataDelegate? { get set }
}
