//
//  ButtonRightSideCustomClass.swift
//  hseProject_1
//
//  Created by Ildar on 8/10/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

@IBDesignable class ButtonRightSideCustomClass: UIButton {

    @IBInspectable
    var roundedCornersOnRight: Bool = false {
        didSet {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
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
