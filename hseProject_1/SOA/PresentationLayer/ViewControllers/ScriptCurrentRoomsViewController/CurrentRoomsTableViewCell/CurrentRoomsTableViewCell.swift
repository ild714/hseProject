//
//  CurrentRoomsTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/11/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CurrentRoomsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRooms: UILabel!
    
    func configure(rooms: String) {
        self.labelRooms.text = rooms
    }
}
