//
//  ParserForRooms.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class SwiftyParser: SwiftyParserProtocol {
    func parseForRooms(data: Data) -> [String: JSON]? {
        return JSON(data).dictionary
    }
}
