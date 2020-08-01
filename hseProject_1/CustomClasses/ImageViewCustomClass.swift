//
//  ImageViewCustomClass.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 31.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

 @IBDesignable class ImageViewCustomClass: UIImageView {

    
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var color: UIColor = .systemBlue {
            didSet {
                self.backgroundColor = color
            }
        }
    
    @IBInspectable
    var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
       var roundedCornersOnRight: Bool = false {
           didSet {
               self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
           }
       }
       
       @IBInspectable
       var roundedCornersOnLeft: Bool = false {
           didSet {
               self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
           }
       }
}
