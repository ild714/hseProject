//
//  ScriptCurrentDaysViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/17/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DaysUpdatedDataProtocol: class {
    func updateScript(script: JSON)
}

class ScriptCurrentDaysViewController: UIViewController {
    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, scriptCreator: JSON, indexOfRooms: Int) {
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        self.indexOfRooms = indexOfRooms
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBOutlet weak var labelDescription: UILabel!
    weak var delegate: DaysUpdatedDataProtocol?
    private var indexOfRooms = 0
    private var dynamicIntForDays = 0
    private var scriptCreator: JSON = []
    private var roomCurrentNumbersAndDays: [Int: [String]] = [:]
    private var presentationAssembly: PresentationAssemblyProtocol?
    private let cellIdentifier = String(describing: CurrentDaysTableViewCell.self)
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: CurrentDaysTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        if !UserDefaults.standard.bool(forKey: "edit") {
            self.dynamicIntForDays = UserDefaults.standard.integer(forKey: "roomGroup\(indexOfRooms)")
        }
        setupNavigationVC()
        daysSavedJsonDataLoader()
        setupTableView()
    }
    func setupNavigationVC() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newDaysGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(showRoomsScriptVC))
    }
    @objc func showRoomsScriptVC() {
        print(scriptCreator)
        delegate?.updateScript(script: self.scriptCreator)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func newDaysGroup() {
        var days: [String] = []
        for value in Array(roomCurrentNumbersAndDays.values) {
            days.append(contentsOf: value)
        }
        if let scriptForDaysVC = presentationAssembly?.scriptForDaysViewController(scriptCreator: self.scriptCreator, daysString: days) {
            scriptForDaysVC.delegate = self
            let navigation = UINavigationController()
            navigation.viewControllers = [scriptForDaysVC]
            present(navigation, animated: true)
        }
    }
    func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: labelDescription.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func showAlert() {
        let alertVC = UIAlertController(title: "Ошибка подключения к wi-fi", message: "Включите wi-fi и перезапустите приложение", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}

// MARK: - ScriptCurrentDaysViewController datasource
extension ScriptCurrentDaysViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomCurrentNumbersAndDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrentDaysTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        var labelArrayString = ""

        for sections in self.roomCurrentNumbersAndDays where sections.key == indexPath.row {
            for section in sections.value {
                labelArrayString += section
                labelArrayString += "\n"
            }
            cell.configure(days: String(labelArrayString.dropLast(1)))
        }
        return cell
    }
}

// MARK: - ScriptCurrentDaysViewController delegate
extension ScriptCurrentDaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let scriptServiceVC = presentationAssembly?.scriptServiceViewController(scriptCreator: self.scriptCreator, previousRoomId: self.indexOfRooms, previousDayId: indexPath.row) {
            scriptServiceVC.delegate = self
            navigationController?.pushViewController(scriptServiceVC, animated: true)
        }
    }
}

// MARK: - ModelRoomsConfigDelegate
extension ScriptCurrentDaysViewController: ScriptForDaysProtocol {
    func save(daysString: [String]) {
        jsonForDaysSection(days: daysString)
        daysDict(days: daysString)
        dynamicIntForDays += 1
        if !UserDefaults.standard.bool(forKey: "edit") {
            UserDefaults.standard.set(dynamicIntForDays, forKey: "roomGroup\(indexOfRooms)")
        }
        tableView.reloadData()
    }

    func jsonForDaysSection(days: [String]) {

        var stringToNumber: [Int] = []
        for day in days {
            switch day {
            case "Понедельник":
                stringToNumber.append(1)
            case "Вторник":
                stringToNumber.append(2)
            case "Среда":
                stringToNumber.append(3)
            case "Четверг":
                stringToNumber.append(4)
            case "Пятница":
                stringToNumber.append(5)
            case "Суббота":
                stringToNumber.append(6)
            case "Воскресенье":
                stringToNumber.append(7)
            default:
                print("error with days")
            }
        }

        let json: JSON = JSON(stringToNumber)
        scriptCreator["roomGroup\(indexOfRooms)"]["dayGroup\(dynamicIntForDays)"] = JSON()
        scriptCreator["roomGroup\(indexOfRooms)"]["dayGroup\(dynamicIntForDays)"]["days"] = json
    }

    func daysDict(days: [String]) {
        self.roomCurrentNumbersAndDays[dynamicIntForDays] = days
    }

}

extension ScriptCurrentDaysViewController {
    func daysSavedJsonDataLoader() {
        print(scriptCreator["roomGroup\(indexOfRooms)"].count)
        for num in 0..<scriptCreator["roomGroup\(indexOfRooms)"].count - 1 {
            var numberToString: [String] = []
            let daysInts = scriptCreator["roomGroup\(indexOfRooms)"]["dayGroup\(num)"]["days"]
            for day in daysInts.arrayValue {
                switch day {
                case 1:
                    numberToString.append("Понедельник")
                case 2:
                    numberToString.append("Вторник")
                case 3:
                    numberToString.append("Среда")
                case 4:
                    numberToString.append("Четверг")
                case 5:
                    numberToString.append("Пятница")
                case 6:
                    numberToString.append("Суббота")
                case 7:
                    numberToString.append("Воскресенье")
                default:
                    print("error with days")
                }
            }
            self.roomCurrentNumbersAndDays[num] = numberToString
        }
    }
}

extension ScriptCurrentDaysViewController: ServiceUpdatedDataProtocol {
    func updateScript(script: JSON) {
        self.scriptCreator = script
    }
}
