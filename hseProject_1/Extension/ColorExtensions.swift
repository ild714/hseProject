//
//  ColorExtensions.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(redS: Int, greenS: Int, blueS: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(redS) / 255.0,
            green: CGFloat(greenS) / 255.0,
            blue: CGFloat(blueS) / 255.0,
            alpha: a
        )
    }
}
