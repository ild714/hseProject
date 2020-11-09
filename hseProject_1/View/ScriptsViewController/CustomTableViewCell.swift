//
//  CustomTableViewCell.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var scriptLabel: UILabel!
    @IBOutlet weak var markImage: UIImageView!
    
    
    func configure(scriptText:String,markBool: Bool){
        
        self.scriptLabel.text = scriptText
        if markBool{
            self.markImage.image = UIImage(named: "check")
        } else {
            self.markImage.image = UIImage(named: "uncheck")
        }
    }
}
