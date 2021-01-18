//
//  ScriptServiceViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/19/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ServiceScript {
    var time: Date = Date()
    var temperature: Int = 0
    var humidity: Int = 0
    var co2: Int = 0
    var radiatorOn = true
    var hotFloorOn = true
    var humidifierOn = true
    var conditionerOn = true
    var co2OnOff = true
    var soundOnOff = true
    var houseOnOff = true
}

class ScriptServiceViewController: UIViewController {

    init?(coder: NSCoder, scriptCreator: JSON) {
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    var indexOfService = 0
    var previousRoomId = 0
    var previousDayId = 0
    private var scriptCreator: JSON = []
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var settingCreator: ViewCustomClass!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var humidityTextField: UITextField!
    @IBOutlet weak var co2TextField: UITextField!
    var showCloseBool = true
    var itemRight: UIBarButtonItem?
    var selectedIndex: Int?
    var selectedIndexChoosed = false
    override func viewDidLoad() {
        super.viewDidLoad()

        humidityTextField.delegate = self
        co2TextField.delegate = self
        temperatureTextField.delegate = self
//        self.navigationItem.setHidesBackButton(true, animated: true)
//        self.navigationController?.navigationBar.backItem?.title = "Назад"
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        setupTableView()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: ScriptServiceTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        tableView.rowHeight = UITableView.automaticDimension

        itemRight = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAndClose))
        navigationItem.rightBarButtonItem = itemRight

        return tableView
    }()

    func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: imageStack.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: settingCreator.topAnchor, constant: -15).isActive = true
    }

    var hightConstraints: NSLayoutConstraint!
    var lowConstraints: NSLayoutConstraint!
    func changeConstraintsHigh() {
        hightConstraints = tableView.bottomAnchor.constraint(equalTo: settingCreator.topAnchor, constant: -15)
        lowConstraints = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        hightConstraints.isActive = false
        lowConstraints.isActive = true
    }
    func changeConstraintsLow() {
        hightConstraints.isActive = true
        lowConstraints.isActive = false
    }
    // Sound changer
    @IBOutlet weak var soundImage: UIButton!
    var soundTurnOn = true
    @IBAction func soundOnOff(_ sender: Any) {
        if soundTurnOn == true {
            soundImage.setImage(UIImage(named: "mute"), for: .normal)
            conditionerTurnOn.toggle()
            conditionerImage.isEnabled = false
            soundTurnOn.toggle()
        } else {
            soundImage.setImage(UIImage(named: "volume"), for: .normal)
            conditionerImage.isEnabled = true
            soundTurnOn.toggle()
        }
    }

    @IBOutlet weak var houseImage: UIButton!
    @IBOutlet weak var temperatureImage: UIImageView!
    @IBOutlet weak var humidityImage: UIImageView!
    var houseTurnOn = true
    @IBAction func houseOnOff(_ sender: Any) {
        if houseTurnOn == true {
            houseImage.setImage(UIImage(named: "not_home"), for: .normal)
            temperatureImage.image = UIImage(named: "темп_min")
            humidityImage.image = UIImage(named: "влажность_max")
            self.humidityTextField.text = "40"
            self.temperatureTextField.text = "24"
            self.temperatureTextField.isEnabled = false
            self.humidityTextField.isEnabled = false
            houseTurnOn.toggle()
        } else {
            houseImage.setImage(UIImage(named: "home"), for: .normal)
            temperatureImage.image = UIImage(named: "темп_б")
            humidityImage.image = UIImage(named: "влажность_б")
            self.temperatureTextField.isEnabled = true
            self.humidityTextField.isEnabled = true
            houseTurnOn.toggle()
        }
    }

    @IBOutlet weak var radiatorImage: UIButton!
    var radiatorTurnOn = true
    @IBAction func radiatorOnOff(_ sender: Any) {
        if radiatorTurnOn == true {
            radiatorImage.setImage(UIImage(named: "not_radiator"), for: .normal)
            radiatorTurnOn.toggle()
        } else {
            radiatorImage.setImage(UIImage(named: "radiator"), for: .normal)
            radiatorTurnOn.toggle()
        }
    }

    @IBOutlet weak var floorImage: UIButton!
    var floorTurnOn = true
    @IBAction func floorOnOff(_ sender: Any) {
        if floorTurnOn == true {
            floorImage.setImage(UIImage(named: "not_hotfloor"), for: .normal)
            floorTurnOn.toggle()
        } else {
            floorImage.setImage(UIImage(named: "hotfloor"), for: .normal)
            floorTurnOn.toggle()
        }
    }

    @IBOutlet weak var humidifierImage: UIButton!
    var humidifierTurnOn = true
    @IBAction func humidifierOnOff(_ sender: Any) {
        if humidifierTurnOn == true {
            humidifierImage.setImage(UIImage(named: "not_humidifier"), for: .normal)
            humidifierTurnOn.toggle()
        } else {
            humidifierImage.setImage(UIImage(named: "humidifier"), for: .normal)
            humidifierTurnOn.toggle()
        }
    }

    @IBOutlet weak var conditionerImage: UIButton!
    var conditionerTurnOn = true
    @IBAction func conditionerOnOff(_ sender: Any) {
        if conditionerTurnOn == true {
           conditionerImage.setImage(UIImage(named: "not_air_conditioner"), for: .normal)
            conditionerTurnOn.toggle()
        } else {
           conditionerImage.setImage(UIImage(named: "air_conditioner"), for: .normal)
            conditionerTurnOn.toggle()
        }
    }

    @IBOutlet weak var co2Image: UIButton!
    var co2TurnOn = true
    @IBAction func co2(_ sender: Any) {
        if co2TurnOn == true {
          co2Image.setImage(UIImage(named: "со2_off"), for: .normal)
            self.co2TextField.text = "--"
            self.co2TextField.isEnabled = false
            co2TurnOn.toggle()
        } else {
           co2Image.setImage(UIImage(named: "со2_on"), for: .normal)
            self.co2TextField.isEnabled = true
            self.co2TextField.text = "800"
            co2TurnOn.toggle()
        }
    }

    var serviceScripts: [ServiceScript] = []

    @objc func saveAndClose() {
        if serviceScripts.count > 0 {
            var setting = SettingCreator(mute: 0, at_home: 0, time: "no time", temp: 24, hum: 40, co2: 800, must_use: [], dont_use: [])

            for serviceScriptNumber in 0..<serviceScripts.count {
                if self.serviceScripts[serviceScriptNumber].soundOnOff == true {
                    setting.mute = 0
                } else {
                    setting.mute = 1
                }

                if self.serviceScripts[serviceScriptNumber].houseOnOff == true {
                    setting.at_home = 1
                } else {
                    setting.at_home = 0
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                setting.time = "\(formatter.string(from: serviceScripts[serviceScriptNumber].time))"

                setting.must_use = []
                setting.hum = serviceScripts[serviceScriptNumber].humidity
                setting.temp = serviceScripts[serviceScriptNumber].temperature
                setting.co2 = serviceScripts[serviceScriptNumber].co2
                setting.dont_use = []

                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"] = JSON()
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["mute"] = JSON(setting.mute)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["at_home"] = JSON(setting.at_home)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["time"] = JSON(setting.time)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["temp"] = JSON(setting.temp)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["hum"] = JSON(setting.hum)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["co2"] = JSON(setting.co2)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["must_use"] = JSON(setting.must_use)
                scriptCreator["roomGroup\(self.previousRoomId)"]["dayGroup\(self.previousDayId)"]["setting\(serviceScriptNumber)"]["dont_use"] = JSON(setting.dont_use)
            }
            //print(scriptCreator)
            let network = NetworkScript()
            network.sentDataScript(script: scriptCreator)
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        } else {
            self.alerts(title: "Не заданы настройки для скрипта", message: "Введите необходимые настройки")
        }
    }

    @IBOutlet weak var closeButtonOrEditButton: ButtonCustomClass!
    @IBAction func addScript(_ sender: Any) {
        self.selectedIndex = nil
        if let text = closeButtonOrEditButton.titleLabel?.text {
            if text == "Сохранить и закончить"{
                saveAndClose()
            }
        }

        var serviceScript = ServiceScript()
        if let temperatureLabelInt = Int(temperatureTextField.text ?? "error") {
            if temperatureLabelInt > 50 || temperatureLabelInt < 15 {
                self.alerts(title: "Некорректное значение для температуры", message: "Ввведите снова показание температуры")
                return
            } else {
                serviceScript.temperature = temperatureLabelInt
            }
        } else {
            self.alerts(title: "Ошибка ввода температуры", message: "Ввведите снова теипературу")
            return
        }

        if let humidityLabelInt = Int(humidityTextField.text ?? "error") {
            if humidityLabelInt < 30 || humidityLabelInt > 80 {
                self.alerts(title: "Некорректное значение для влажности", message: "Ввведите снова показание влжаности")
                return
            } else {
                serviceScript.humidity = humidityLabelInt
            }
        } else {
            self.alerts(title: "Ошибка ввода влажности", message: "Ввведите снова влажность")
            return
        }
        if co2TurnOn == false {
            serviceScript.co2 = 0
        } else {
            if let co2TextField = Int(co2TextField.text ?? "error") {
                if co2TextField < 500 || co2TextField > 1000 {
                    self.alerts(title: "Некорректное значение для CO2", message: "Ввведите снова показание для СО2")
                    return
                } else {
                    serviceScript.co2 = co2TextField
                }
            } else {
                self.alerts(title: "Ошибка ввода СО2", message: "Ввведите снова СО2")
                return
            }
        }

        serviceScript.conditionerOn = conditionerTurnOn
        serviceScript.hotFloorOn = floorTurnOn
        serviceScript.humidifierOn = humidifierTurnOn
        serviceScript.radiatorOn = radiatorTurnOn
        serviceScript.time = timePicker.date
        serviceScript.co2OnOff = co2TurnOn
        serviceScript.houseOnOff = houseTurnOn
        serviceScript.soundOnOff = soundTurnOn

        serviceScripts.append(serviceScript)
        tableView.reloadData()
    }

    func alerts(title: String, message: String) {
        let vcAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(vcAlert, animated: true)
    }
    let cellIdentifier = String(describing: ScriptServiceTableViewCell.self)

    static func storyboardInstance() -> ScriptServiceViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptServiceViewController
    }
    @IBAction func previousStep(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
}

// MARK: - ScriptServiceViewController dataSource methods
extension ScriptServiceViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceScripts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScriptServiceTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.index = indexPath.row
        cell.congigure(serviveScript: serviceScripts[indexPath.row], number: indexPath.row + 1)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) as? ScriptServiceTableViewCell != nil {

            if showCloseBool {
                self.selectedIndex = indexPath.row
                self.selectedIndexChoosed = true
                UIView.animate(withDuration: 1) {
                    self.changeConstraintsHigh()
                    self.view.layoutIfNeeded()
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                serviceLabel.text = "Изменяйте желаемые настройки"

                closeButtonOrEditButton.setTitle("Сохранить и закончить", for: .normal)
                UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    self.settingCreator.alpha = 0
                })
                self.navigationItem.setRightBarButton(nil, animated: true)
                showCloseBool.toggle()
            } else {
                self.selectedIndex = indexPath.row
                self.selectedIndexChoosed = false
                UIView.animate(withDuration: 1) {
                    self.changeConstraintsLow()
                    self.view.layoutIfNeeded()
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                serviceLabel.text = "Добавляйте желаемые настройки"
                closeButtonOrEditButton.setTitle("Добавить настройку", for: .normal)
                UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    self.settingCreator.alpha = 1
                })
                self.navigationItem.setRightBarButton(itemRight, animated: true)
                showCloseBool.toggle()
            }
        }
    }
}

// MARK: - ScriptServiceViewController delegate methods
extension ScriptServiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndex = self.selectedIndex {
            if indexPath.row == selectedIndex && selectedIndexChoosed {
                return 180
            } else {
                return 50
            }
        } else {
            return 50
        }
    }
}

extension ScriptServiceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
