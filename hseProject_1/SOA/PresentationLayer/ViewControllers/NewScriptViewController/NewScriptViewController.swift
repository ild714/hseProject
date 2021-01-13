//
//  NewScriptViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class NewScriptViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var presentationAssembly: PresentationAssemblyProtocol?

    @IBOutlet weak var textField: UITextField!
    var scriptCreator = ScriptCreator(did: "", name: "", roomGroup0: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        textField.delegate = self
        textField.placeholder = "Новый сценарий"
        textField.layer.cornerRadius = 50
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    static func storyboardInstance() -> NewScriptViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? NewScriptViewController
    }
    @IBAction func nextStep(_ sender: Any) {
        scriptCreator.name = textFieldForScript.text ?? "Test1"
        scriptCreator.did = "10155"
        if let scriptForRoomVC = presentationAssembly?.scriptForRoomViewController(scriptCreator: self.scriptCreator) {
            navigationController?.pushViewController(scriptForRoomVC, animated: true)
        }
    }

    @IBOutlet weak var textFieldForScript: UITextField!
    @IBAction func nameForScriptCreater(_ sender: Any) {

    }

}

extension NewScriptViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
