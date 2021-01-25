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
            if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(name: textFieldForScript.text ?? "Test1", rooms: []) {
                navigationController?.pushViewController(currentRoomsVC, animated: true)
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
    @IBAction func nextStep(_ sender: Any) {
        if textFieldForScript.text?.isEmpty == true {
            alert(title: "Ошибка ввода названия скрипта", message: "Введите название для скрипта")
        } else {
            if let currentRoomsVC = presentationAssembly?.currentRoomsViewController(name: textFieldForScript.text ?? "Test1", rooms: []) {
                navigationController?.pushViewController(currentRoomsVC, animated: true)
            }
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
