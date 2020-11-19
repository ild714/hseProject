//
//  NewScriptViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class NewScriptViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.placeholder = "Новый сценарий"
        textField.layer.cornerRadius = 50
    }
    
    static func storyboardInstance() -> NewScriptViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? NewScriptViewController
    }
    @IBAction func nextStep(_ sender: Any) {
        if let vc = ScriptForRoomViewController.storyboardInstance(){
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
