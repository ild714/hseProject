//
//  ScriptForRoomTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptForRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var markImage: UIImageView!
    
    func configure(room:String,markBool: Bool){
        
        self.roomLabel.text = room
        if markBool{
            self.markImage.image = UIImage(named: "check")
        } else {
            self.markImage.image = UIImage(named: "uncheck")
        }
    }
    
}
