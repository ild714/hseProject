//
//  NewScriptViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewScriptViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var presentationAssembly: PresentationAssemblyProtocol?
    var scriptCreator: JSON = JSON()
    var dynamicInt = 0
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        textField.delegate = self
        textField.placeholder = "Новый сценарий"
        textField.layer.cornerRadius = 50
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Дальше", style: .plain, target: self, action: #selector(roomsGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)

    }

    @objc func roomsGroup() {
        if textFieldForScript.text?.isEmpty == true {
            alert(title: "Ошибка ввода названия скрипта", message: "Введите название для скрипта")
        } else {
            if scriptCreator.isEmpty {
                scriptCreator["did"] = JSON("10153")
                scriptCreator["name"] = JSON(textFieldForScript.text ?? "Test1?")
                print(scriptCreator)
                if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(scriptCreator: scriptCreator, rooms: []) {
                    currentRoomsVC.delegate = self
                    navigationController?.pushViewController(currentRoomsVC, animated: true)
                }
            } else {
                print(scriptCreator)
                if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(scriptCreator: scriptCreator, rooms: []) {
                    currentRoomsVC.delegate = self
                    currentRoomsVC.dynamicInt = self.dynamicInt
                    navigationController?.pushViewController(currentRoomsVC, animated: true)
                }
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    static func storyboardInstance() -> NewScriptViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? NewScriptViewController
    }
    func alert(title: String, message: String) {
        let vcAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(vcAlert, animated: true)
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

extension NewScriptViewController: NewScriptUpdatedDataProtocol {
    func updateScript(script: JSON, dynamicInt: Int) {
        self.scriptCreator = script
        self.dynamicInt = dynamicInt
    }

}
