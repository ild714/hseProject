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
    var dynamicIntForRooms = 0
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboard()
        configureTextField()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Дальше", style: .plain, target: self, action: #selector(roomsGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
    func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func configureTextField() {
        textField.delegate = self
        textField.placeholder = "Новый сценарий"
        textField.layer.cornerRadius = 50
    }
    override func viewWillDisappear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.contains("room") || key.contains("Scripts") {
                print(key)
                defaults.removeObject(forKey: key)
            }
        }
    }
    @objc func roomsGroup() {
        if textField.text?.isEmpty == true {
            alert(title: "Ошибка ввода названия скрипта", message: "Введите название для скрипта")
        } else {
            if scriptCreator.isEmpty {
                scriptCreator["did"] = JSON("10155")
                scriptCreator["name"] = JSON(textField.text ?? "Test1?")
                print(scriptCreator)
                if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(scriptCreator: scriptCreator, rooms: [], dynamicIntForRooms: self.dynamicIntForRooms) {
                    currentRoomsVC.delegate = self
                    navigationController?.pushViewController(currentRoomsVC, animated: true)
                }
            } else {
                print(scriptCreator)
                if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(scriptCreator: scriptCreator, rooms: [], dynamicIntForRooms: self.dynamicIntForRooms) {
                    currentRoomsVC.delegate = self
                    navigationController?.pushViewController(currentRoomsVC, animated: true)
                }
            }
        }
    }

    func alert(title: String, message: String) {
        let vcAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(vcAlert, animated: true)
    }
}

extension NewScriptViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

extension NewScriptViewController: NewScriptUpdatedDataProtocol {
    func updateScript(script: JSON, dynamicIntForRooms: Int) {
        self.scriptCreator = script
        self.dynamicIntForRooms = dynamicIntForRooms
    }

}
