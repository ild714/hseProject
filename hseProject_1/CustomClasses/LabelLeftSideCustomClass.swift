//
//  LabelLeftSideCustomClass.swift
//  hseProject_1
//
//  Created by Ildar on 8/10/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

@IBDesignable class LabelLeftSideCustomClass: UILabel {

    @IBInspectable
    var roundedCornersOnLeft: Bool = false {
        didSet {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }

}
