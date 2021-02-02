//
//  ModelsAppDatchikProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 2/2/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

protocol ModelAppDatchikProtocol {
    func fetchAppDatchik<T>(type: TypeOfSensor, completion: @escaping (T) -> Void)
    var delegate: ModelAppDatchikDelegate? { get set }
}
