//
//  LaunchScreenViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 4/12/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    static func storyboardInstance() -> LaunchScreenViewController? {
        let storyboard = UIStoryboard(name: "LaunchScreenViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? LaunchScreenViewController
    }
}
