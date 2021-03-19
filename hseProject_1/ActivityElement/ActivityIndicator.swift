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

struct ViewSpecialAndGeneral {
    var typeOfActivity: SpecialActivity = .general
    var view: UIView = UIView()

    init(view: UIView, type: SpecialActivity = .general) {
        self.view = view
        self.typeOfActivity = type
    }
}

struct LabelActivity {
    var label: UILabel = UILabel()

    init(label: UILabel) {
        self.label = label
    }
}

class ActivityIndicator {
    private init() {}
    
    static func animateView(view: UIView) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.center.x = view.center.x / 2
        activityIndicator.center.y = view.center.y / 2
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
    }
    
    static func animateActivityLabel(labels: [LabelActivity]) {

        for label in labels {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            activityIndicator.center.x = 20
            activityIndicator.center.y = 15
            activityIndicator.startAnimating()
            label.label.addSubview(activityIndicator)
        }
    }

    static func animateActivity(views: [ViewSpecialAndGeneral]) {

        for view in views {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            activityIndicator.center.x = view.view.bounds.size.width / 2
            if view.typeOfActivity == .special {
                activityIndicator.center.y = view.view.bounds.size.height / 2 - 8
            } else {
                activityIndicator.center.y = view.view.bounds.size.height / 2
            }
            activityIndicator.startAnimating()
            view.view.addSubview(activityIndicator)
        }
    }

    static func stopAnimating(views: [UIView]) {
        for view in views {
            view.subviews.forEach {$0.removeFromSuperview()}
        }
    }
}
