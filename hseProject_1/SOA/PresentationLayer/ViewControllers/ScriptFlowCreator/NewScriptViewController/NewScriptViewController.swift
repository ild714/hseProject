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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Сценарии", style: .plain, target: self, action: #selector(backToScripts))
    }
    @objc func backToScripts() {
        print(scriptCreator)
        if scriptCreator.count == 0 {
            showAlertScript()
        } else if scriptCreator.count == 2 {
            showAlertScript()
        } else {
            var allDays: [Int] = []
            for index in 0..<scriptCreator.count - 2 {
                if scriptCreator["roomGroup\(index)"].count == 1 {
                    showAlertScript()
                    break
                } else {
                    for indexDays in 0..<scriptCreator["roomGroup\(index)"].count - 1 {
                        let days = scriptCreator["roomGroup\(index)"]["dayGroup\(indexDays)"]["days"]
                        for day in days.arrayValue {
                            allDays.append(day.intValue)
                        }
                    }
                    print(allDays)
                }
                if allDays.count < 7 {
                    showAlertScript()
                    allDays.removeAll()
                } else {
                    allDays.removeAll()
                    for indexDays in 0..<scriptCreator["roomGroup\(index)"].count - 1 where scriptCreator["roomGroup\(index)"]["dayGroup\(indexDays)"].count < 2  {
                        showAlertScript()
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
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
    func showAlertScript() {
//        let alertVC = UIAlertController(title: "Вы заполнили не весь сценарий", message: "Хотите сохрнаить как черновик?", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "Да", style: .default, handler: {_ in
//            self.navigationController?.popViewController(animated: true)
//        }))
//        alertVC.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        let alertVC = UIAlertController(title: "Вы заполнили не весь сценарий", message: "Заполните оставшиеся настройки", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alertVC, animated: true)
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
