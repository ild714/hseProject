//
//  ViewController.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var roomNumber: UILabel!
    
    @IBOutlet weak var temperatureImage: ImageViewCustomClass!
    @IBOutlet weak var temperatureText: UILabel!
    @IBOutlet weak var temperatureCurrent: UILabel!
    @IBOutlet weak var temperatureAim: LabelCustomClass!
    
    
    @IBOutlet weak var wetImage: ImageViewCustomClass!
    @IBOutlet weak var wetText: UILabel!
    @IBOutlet weak var wetCurrent: UILabel!
    @IBOutlet weak var wetAim: LabelCustomClass!
    
    @IBOutlet weak var gasImage: ImageViewCustomClass!
    @IBOutlet weak var gasText: LabelCustomClass!
    @IBOutlet weak var gasCurrent: LabelCustomClass!
    @IBOutlet weak var gasAim: LabelCustomClass!
    
    @IBOutlet weak var peopleText: LabelCustomClass!
    @IBOutlet weak var peopleNumber: LabelCustomClass!
    
    @IBOutlet weak var ventilateRoom: ButtonCustomClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    

}

