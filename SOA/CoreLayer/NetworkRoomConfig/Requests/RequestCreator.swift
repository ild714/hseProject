//
//  RequestCreator.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation

struct RequestCreator {
    static func newRoomsConfig() -> RequestConfig<SwiftyParser> {
        return RequestConfig<SwiftyParser>(request: RoomsRequest(), parser: SwiftyParser())
    }
}
