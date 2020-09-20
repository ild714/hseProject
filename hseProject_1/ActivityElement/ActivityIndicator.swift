//
//  ActivityIndicator.swift
//  hseProject_1
//
//  Created by Ildar on 8/11/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import Foundation
import UIKit

enum SpecialActivity {
    case special
    case general
}

class ActivityIndicator {
    private init() {}
    
    static func animateActivity(view: UIView,typeOfActivity: SpecialActivity = .general) {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.center.x = view.bounds.size.width / 2
        if typeOfActivity == .special {
            activityIndicator.center.y = view.bounds.size.height / 2 - 5
        } else {
            activityIndicator.center.y = view.bounds.size.height / 2
        }
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    static func stopAnimating(view: UIView) {
        view.subviews.forEach{$0.removeFromSuperview()}
    }
}
