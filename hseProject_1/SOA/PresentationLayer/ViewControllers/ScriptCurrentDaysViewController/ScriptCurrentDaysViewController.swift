//
//  ScriptCurrentDaysViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/17/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScriptCurrentDaysViewController: UIViewController {
    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, scriptCreator: JSON) {
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var previousNumber = 0
    var dynamicInt = 0
    var scriptCreator: JSON = []
    var roomCurrentNumbersAndDays: [Int: [String]] = [:]
    private var presentationAssembly: PresentationAssemblyProtocol?
    @IBOutlet weak var labelDescription: UILabel!
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newDaysGroup))
        setupTableView()
//        self.navigationController?.navigationBar.backItem?.title = "Назад"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
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

        for sections in self.roomCurrentNumbersAndDays {
            if sections.key == indexPath.row {
                for section in sections.value {
                    labelArrayString += section
                    labelArrayString += "\n"
                }
                cell.configure(days: labelArrayString)
            } else {
            }
        }

        return cell
    }
}

// MARK: - ScriptCurrentDaysViewController delegate
extension ScriptCurrentDaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let scriptForDaysVC = presentationAssembly?.scriptServiceViewController(scriptCreator: self.scriptCreator) {
            scriptForDaysVC.previousRoomId = self.previousNumber
            scriptForDaysVC.previousDayId = indexPath.row
            navigationController?.pushViewController(scriptForDaysVC, animated: true)
        }
    }
}

// MARK: - ModelRoomsConfigDelegate
extension ScriptCurrentDaysViewController: ScriptForDaysProtocol {
    func save(daysString: [String]) {
        jsonForDaysSection(days: daysString)
        daysDict(days: daysString)
        dynamicInt += 1
        tableView.reloadData()
    }

    func jsonForDaysSection(days: [String]) {

        var stringToNumber: [Int] = []
        for day in days {
            switch day {
            case "Понедельник":
                stringToNumber.append(0)
            case "Вторник":
                stringToNumber.append(1)
            case "Среда":
                stringToNumber.append(2)
            case "Четверг":
                stringToNumber.append(3)
            case "Пятница":
                stringToNumber.append(4)
            case "Суббота":
                stringToNumber.append(5)
            case "Воскресенье":
                stringToNumber.append(6)
            default:
                print("error with days")
            }
        }

        let json: JSON = JSON(stringToNumber)
        scriptCreator["roomGroup\(previousNumber)"]["dayGroup\(dynamicInt)"] = JSON()
        scriptCreator["roomGroup\(previousNumber)"]["dayGroup\(dynamicInt)"]["days"] = json
    }

    func daysDict(days: [String]) {
        self.roomCurrentNumbersAndDays[dynamicInt] = days
    }
}
