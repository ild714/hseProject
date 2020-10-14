//
//  CustomCollectionViewCell.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var roomNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    
    func configure(nameRoom:String){
        
        roomNameLabel.text = nameRoom
    }
    
}
