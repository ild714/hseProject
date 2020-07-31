//
//  viewExtension.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 30.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

@IBDesignable
class SemiRoundLabel: UILabel {
   
//    @IBInspectable var radius: Int = 5  // Int needed for IBInspectable
//    @IBInspectable var borderColor: UIColor = .black
//    @IBInspectable var topLeft: Bool = true
//    @IBInspectable var topRight: Bool = false
//    @IBInspectable var bottomRight: Bool = true
//    @IBInspectable var bottomLeft: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupView()
    }

    func setupView() {
//        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
//        self.layer.shadowColor = shadowColor.cgColor
//        self.layer.shadowRadius = shadowRadius
//        self.layer.shadowOpacity = shadowOpacity
//        self.layer.borderWidth = borderWidth
//        self.layer.borderColor = borderColor.cgColor
//        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        self.layer.cornerRadius = 10
    }
    
    // MARK: - Properties
//    @IBInspectable
//    var color: UIColor = .systemBlue {
//        didSet {
//            self.backgroundColor = color
//        }
//    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

//    @IBInspectable
//    var shadowColor: UIColor = .black {
//        didSet {
//            self.layer.shadowColor = shadowColor.cgColor
//        }
//    }
    
//    @IBInspectable
//    var shadowRadius: CGFloat = 0 {
//        didSet {
//            self.layer.shadowRadius = shadowRadius
//        }
//    }
//    
//    @IBInspectable
//    var shadowOpacity: Float = 0 {
//        didSet {
//            self.layer.shadowOpacity = shadowOpacity
//        }
//    }
//    
//    @IBInspectable
//    var borderWidth: CGFloat = 0 {
//        didSet {
//            self.layer.borderWidth = borderWidth
//        }
//    }
    
//    @IBInspectable
//    var borderColor: UIColor = .white {
//        didSet {
//            self.layer.borderColor = borderColor.cgColor
//        }
//    }
    
    
//    override func draw(_ rect: CGRect) {
//
//        var corners : CACornerMask = []
//        if topLeft { corners.insert(.layerMinXMinYCorner) }
//        if topRight { corners.insert(.layerMaxXMinYCorner) }
//        if bottomRight { corners.insert(.layerMaxXMaxYCorner) }
//        if bottomLeft { corners.insert(.layerMinXMaxYCorner) }

//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = path.cgPath
//        self.layer.mask = maskLayer
//
//        self.backgroundColor?.setFill()
//        path.fill()
//        borderColor.setStroke()
//        path.stroke()
//        let textToDraw = self.attributedText!
//        textToDraw.draw(in: rect)
        
//        self.layer.maskedCorners = corners
//    }
}
