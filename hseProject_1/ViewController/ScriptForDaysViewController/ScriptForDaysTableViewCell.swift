//
//  ScriptForDaysTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptForDaysTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var markImage: UIImageView!
    
    func configure(day:String,markBool: Bool){
        
        self.labelDay.text = day
        if markBool{
            self.markImage.image = UIImage(named: "check")
        } else {
            self.markImage.image = UIImage(named: "uncheck")
        }
    }
}
