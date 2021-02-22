//
//  ButtonLeftSideCustomClass.swift
//  hseProject_1
//
//  Created by Ildar on 8/10/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

@IBDesignable class ButtonLeftSideCustomClass: UIButton {

    @IBInspectable
    var roundedCornersOnLeft: Bool = false {
        didSet {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 10 {
        didSet {
//            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.setImage(UIImage(named: "icons8-subtract-50 (1)"), for: .normal)
            } else {
                self.setImage(UIImage(named: "icons8-subtract-50"), for: .normal)
            }
        }
    }

}
