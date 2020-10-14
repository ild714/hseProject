//
//  PageCell.swift
//  hseProject_1
//
//  Created by Ildar on 10/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
