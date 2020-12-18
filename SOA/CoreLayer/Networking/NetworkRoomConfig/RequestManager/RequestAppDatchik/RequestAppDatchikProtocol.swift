//
//  RequestAppDatchikProtocol.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/18/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

protocol RequestAppDatchikProtocol {
    func load<Parser, T>(requestConfig: RequestConfig<Parser>, type sensorType: TypeOfSensor, completion:@escaping (Result<T, NetworkSensorError>) -> Void)
}
