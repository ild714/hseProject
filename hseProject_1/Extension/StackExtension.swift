//
//  StackExtension.swift
//  hseProject_1
//
//  Created by Ildar on 9/20/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

extension UIStackView {
    func backColor(stackView: UIStackView){
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.white
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.insertSubview(backgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: stackView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
}
