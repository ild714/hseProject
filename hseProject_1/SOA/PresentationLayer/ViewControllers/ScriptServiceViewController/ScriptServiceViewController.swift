//
//  ScriptServiceViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/19/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

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

    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var settingCreator: ViewCustomClass!
    @IBOutlet weak var temperatureLabel: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var humidityLabel: UITextField!
    @IBOutlet weak var co2TextField: UITextField!
    var showCloseBool = true
    var scriptCreator: ScriptCreator?
    var itemRight: UIBarButtonItem?

    private let pickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0.0, y: 300.0, width: 100.0, height: 300.0))

    override func viewDidLoad() {
        super.viewDidLoad()

        humidityLabel.delegate = self
        co2TextField.delegate = self
        temperatureLabel.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
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

    // Sound changer
    @IBOutlet weak var soundImage: UIButton!
    var soundTurnOn = true
    @IBAction func soundOnOff(_ sender: Any) {
        if soundTurnOn == true {
            soundImage.setImage(UIImage(named: "mute"), for: .normal)
            soundTurnOn.toggle()
        } else {
            soundImage.setImage(UIImage(named: "volume"), for: .normal)
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
            self.humidityLabel.text = "40"
            self.temperatureLabel.text = "24"
            houseTurnOn.toggle()
        } else {
            houseImage.setImage(UIImage(named: "home"), for: .normal)
            temperatureImage.image = UIImage(named: "темп_б")
            humidityImage.image = UIImage(named: "влажность_б")
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
            co2TurnOn.toggle()
        } else {
           co2Image.setImage(UIImage(named: "со2_on"), for: .normal)
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

            self.scriptCreator?.roomGroup0?.dayGroup0?.setting0 = setting
            self.scriptCreator?.roomGroup0?.dayGroup0?.setting1 = setting

            let network = NetworkScript()
            if let script = scriptCreator {
                network.sentDataScript(script: script)
            }
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
        return
        } else {
            let vcAlert = UIAlertController(title: "Не заданы настройки для скрипта", message: "Введите необходимые настройки", preferredStyle: .alert)
            vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(vcAlert, animated: true)
        }
    }

    @IBOutlet weak var closeButtonOrEditButton: ButtonCustomClass!
    @IBAction func addScript(_ sender: Any) {
        if let text = closeButtonOrEditButton.titleLabel?.text {
            if text == "Сохранить и закончить"{
                saveAndClose()
            }
        }

        var serviceScript = ServiceScript()
        if let temperatureLabelInt = Int(temperatureLabel.text ?? "error") {
            if temperatureLabelInt > 50 || temperatureLabelInt < 15 {
                let alert = UIAlertController(title: "Некорректное значение для температуры", message: "Ввведите снова показание температуры", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            } else {
                serviceScript.temperature = temperatureLabelInt
            }
        } else {
            let alert = UIAlertController(title: "Ошибка ввода температуры", message: "Ввведите снова теипературу", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        if let humidityLabelInt = Int(humidityLabel.text ?? "error") {
            if humidityLabelInt < 30 || humidityLabelInt > 80 {
                let alert = UIAlertController(title: "Некорректное значение для влажности", message: "Ввведите снова показание влжаности", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            } else {
                serviceScript.humidity = humidityLabelInt
            }
        } else {
            let alert = UIAlertController(title: "Ошибка ввода влажности", message: "Ввведите снова влажность", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        if co2TurnOn == false {
            serviceScript.co2 = 0
        } else {
            if let co2TextField = Int(co2TextField.text ?? "error") {
                if co2TextField < 500 || co2TextField > 1000 {
                    let alert = UIAlertController(title: "Некорректное значение для CO2", message: "Ввведите снова показание для СО2", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                } else {
                    serviceScript.co2 = co2TextField
                }
            } else {
                let alert = UIAlertController(title: "Ошибка ввода СО2", message: "Ввведите снова СО2", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
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
                tableView.rowHeight = 180
                UIView.animate(withDuration: 1) {
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
                tableView.rowHeight = 50
                UIView.animate(withDuration: 1) {
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

}

extension ScriptServiceViewController: cellDelagate {
    func updateCO2(number: Int, co2: Int, co2OnOff: Bool) {
        self.serviceScripts[number].co2 = co2
        self.serviceScripts[number].co2OnOff = co2OnOff
        tableView.reloadData()
    }

    func updateTime(number: Int, time: Date) {
        self.serviceScripts[number].time = time
        print(serviceScripts[number].time)
        tableView.reloadData()
    }

    func updateTemperature(number: Int, temperature: Int) {
        self.serviceScripts[number].temperature = temperature
        tableView.reloadData()
    }

    func updateHumidity(number: Int, humidity: Int) {
        self.serviceScripts[number].humidity = humidity
        tableView.reloadData()
    }

    func updateHouse(number: Int, houseOnOff: Bool) {
        if self.serviceScripts[number].hotFloorOn {
            self.serviceScripts[number].temperature = 24
            self.serviceScripts[number].humidity = 40
            self.serviceScripts[number].houseOnOff = houseOnOff
            tableView.reloadData()
        } else {
            self.serviceScripts[number].houseOnOff = houseOnOff
            tableView.reloadData()
        }
    }

    func updateSound(number: Int, soundOnOff: Bool) {
        self.serviceScripts[number].soundOnOff = soundOnOff
        tableView.reloadData()
    }
}

extension ScriptServiceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
