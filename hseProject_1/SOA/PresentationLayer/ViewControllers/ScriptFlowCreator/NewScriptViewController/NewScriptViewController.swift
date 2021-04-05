//
//  NewScriptViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UpdateScripts: class {
    func update()
}

class NewScriptViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, scriptCreator: JSON) {
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    weak var delegate: UpdateScripts?
    private var presentationAssembly: PresentationAssemblyProtocol?
    var scriptCreator: JSON = JSON()
    var dynamicIntForRooms = 0
    @IBOutlet weak var textField: UITextField!
    var notNewScript = true

    override func viewDidLoad() {
        super.viewDidLoad()
        print("!!!!!")
        print(scriptCreator)
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
            var localBool = true
            var arrayBools: [Bool] = []
            var countRooms: Int = 0
            for index in 0..<scriptCreator.count - 2 {
                localBool = true
                if scriptCreator["roomGroup\(index)"].count == 1 {
                    localBool = false
                } else {
                    countRooms += scriptCreator["roomGroup\(index)"]["rIDs"].array?.count ?? 100

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
                    localBool = false
                } else {
                    print(scriptCreator)
                    allDays.removeAll()
                    for indexDays in 0..<scriptCreator["roomGroup\(index)"].count - 1 where scriptCreator["roomGroup\(index)"]["dayGroup\(indexDays)"].count < 2 {
                        localBool = false
                    }
                }
                arrayBools.append(localBool)
            }
            if arrayBools.allSatisfy({$0}) {
                if UserDefaults.standard.bool(forKey: "edit") {
                    let updateScript = UpdateScript()
                    self.scriptCreator["sc_id"] = JSON(UserDefaults.standard.integer(forKey: "id"))
                    self.scriptCreator["name"] = JSON(self.textField.text ?? "Test1?")
//                    print("?!!")
//                    print(self.scriptCreator)
                    updateScript.sentUpdateDataScript(script: self.scriptCreator)
                    UserDefaults.standard.set(false, forKey: "edit")
                    self.delegate?.update()
                    self.navigationController?.popViewController(animated: true)
                } else
                if countRooms == UserDefaults.standard.integer(forKey: "RoomsCount") {
                    showSaveScript(script: self.scriptCreator)
                } else {
                    showAlertScript()
                }
            } else {
                showAlertScript()
            }
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
        let text1 = self.scriptCreator["name"]
        textField.text = text1.string
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
                if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(scriptCreator: scriptCreator, rooms: [], dynamicIntForRooms: self.dynamicIntForRooms) {
                    currentRoomsVC.delegate = self
                    navigationController?.pushViewController(currentRoomsVC, animated: true)
                }
            } else {
                scriptCreator["name"] = JSON(textField.text ?? "Test1?")
                if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(scriptCreator: scriptCreator, rooms: [], dynamicIntForRooms: self.dynamicIntForRooms) {
                    currentRoomsVC.delegate = self
                    navigationController?.pushViewController(currentRoomsVC, animated: true)
                }
            }
        }
    }
    func scriptDraftSave() {
        if textField.text?.isEmpty == true {
            alert(title: "Ошибка ввода названия скрипта", message: "Введите название для скрипта")
        } else {
            if scriptCreator.isEmpty {
                scriptCreator["did"] = JSON("10155")
                scriptCreator["name"] = JSON(textField.text ?? "Test1?")
            } else {
            }
        }
    }
    func showSaveScript(script: JSON) {
//        if UserDefaults.standard.bool(forKey: "edit") {
//            let updateScript = UpdateScript()
//            self.scriptCreator["sc_id"] = JSON(UserDefaults.standard.integer(forKey: "id"))
//            self.scriptCreator["name"] = JSON(self.textField.text ?? "Test1?")
//            print("?!!")
//            print(self.scriptCreator)
//            updateScript.sentUpdateDataScript(script: self.scriptCreator)
//            UserDefaults.standard.set(false, forKey: "edit")
//            self.delegate?.update()
//            self.navigationController?.popViewController(animated: true)
        
//            let alertVC = UIAlertController(title: "Вы не сохранили обновленный сценарий", message: "Хотите сохранить", preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction(title: "Да", style: .default, handler: {[weak self]_ in
//                print(UserDefaults.standard.integer(forKey: "id"))
//                self?.scriptCreator["sc_id"] = JSON(UserDefaults.standard.integer(forKey: "id"))
//                self?.scriptCreator["name"] = JSON(self?.textField.text ?? "Test1?")
//                print("?!!")
//
//                let updateScript = UpdateScript()
//                if let scriptCreator = self?.scriptCreator {
//                    print(self?.scriptCreator)
//                updateScript.sentUpdateDataScript(script: scriptCreator)
//                } else {
//                    print("error with scriptCreator")
//                }
//                UserDefaults.standard.set(false, forKey: "edit")
//                self?.delegate?.update()
//                self?.navigationController?.popViewController(animated: true)
//
//            }))
//            alertVC.addAction(UIAlertAction(title: "Нет", style: .default, handler: {_ in
//                UserDefaults.standard.set(false, forKey: "edit")
//                self.navigationController?.popViewController(animated: true)
//            }))
//            self.present(alertVC, animated: true)
//        } else {
        let alertVC = UIAlertController(title: "Вы не сохранили сценарий", message: "Хотите сохранить", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Да", style: .default, handler: {_ in
            let network = NetworkScript()
            network.sentDataScript(script: script)

            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                if key.contains("Json\(0+UserDefaults.standard.integer(forKey: "LastJSON"))") {
                    print(key, "---")
                    defaults.removeObject(forKey: key)
                    let count = UserDefaults.standard.integer(forKey: "JSONCount")
                    print(count, "!-!")
                    UserDefaults.standard.set(count-1, forKey: "JSONCount")
                }
            }
            self.delegate?.update()
            self.navigationController?.popViewController(animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Нет", style: .default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertVC, animated: true)
//        }
    }
    func exitForTheServer() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.contains("room") || key.contains("Scripts") || key.contains("dynamicIntForRooms") {
                print(key)
                defaults.removeObject(forKey: key)
            }
        }
        
        UserDefaults.standard.set(0 + UserDefaults.standard.integer(forKey: "LastJSON"), forKey: "CurrentJSON")
        
        UserDefaults.standard.set(false, forKey: "edit")
    }
    func showAlertScript() {
        if UserDefaults.standard.bool(forKey: "edit") {
            //exitForTheServer()
        }
        
        self.scriptDraftSave()
        let alertVC = UIAlertController(title: "Вы заполнили не весь сценарий", message: "Хотите сохрнить как черновик?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Да", style: .default, handler: {_ in
            print(self.scriptCreator)
            var countScript = 0
            if let countScriptDefaults = try? UserDefaults.standard.integer(forKey: "JSONCount") {
                    countScript = countScriptDefaults
            } else {
                UserDefaults.standard.set(0, forKey: "JSONCount")
            }
            UserDefaults.standard.set(countScript+1, forKey: "JSONCount")
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                if key.contains("Json\(UserDefaults.standard.integer(forKey: "CurrentJSON"))") {
                    print(key, "???")
//                    if self.notNewScript {
                        defaults.removeObject(forKey: key)
                        var count = UserDefaults.standard.integer(forKey: "JSONCount")
                        UserDefaults.standard.set(count-1, forKey: "JSONCount")
                        UserDefaults.standard.set(countScript+1, forKey: "LastJSON")
//                    }
                } else {
                    print(countScript+1)
                    UserDefaults.standard.set(countScript+1, forKey: "LastJSON")
                }
            }
            try? UserDefaults.standard.set(self.scriptCreator.rawData(), forKey: "Json\(countScript+1)")
            self.navigationController?.popViewController(animated: true)
            self.delegate?.update()
        }))
        alertVC.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
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
