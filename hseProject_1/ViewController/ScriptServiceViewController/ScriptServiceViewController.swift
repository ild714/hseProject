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
    var radiatorOn = true
    var hotFloorOn = true
    var humidifierOn = true
    var conditionerOn = true
}

class ScriptServiceViewController: UIViewController {

    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var settingCreator: ViewCustomClass!
    @IBOutlet weak var temperatureLabel: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var humidityLabel: UITextField!
    
    private let pickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0.0, y: 300.0, width: 100.0, height: 300.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupTableView()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: ScriptServiceTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        return tableView
    }()
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: imageStack.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: settingCreator.topAnchor,constant: -15).isActive = true
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
    
    var serviceScripts: [ServiceScript] = []
    
    @IBAction func addScript(_ sender: Any) {
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
        
        serviceScript.conditionerOn = conditionerTurnOn
        serviceScript.hotFloorOn = floorTurnOn
        serviceScript.humidifierOn = humidifierTurnOn
        serviceScript.radiatorOn = radiatorTurnOn
        serviceScript.time = timePicker.date
        
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
        cell.congigure(serviveScript: serviceScripts[indexPath.row], number: indexPath.row + 1)
        
        return cell
    }
}

// MARK: - ScriptServiceViewController delegate methods
extension ScriptServiceViewController: UITableViewDelegate {
    
}
