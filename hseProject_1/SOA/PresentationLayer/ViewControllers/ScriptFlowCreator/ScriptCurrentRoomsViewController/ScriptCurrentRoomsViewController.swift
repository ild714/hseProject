//
//  CurrentRoomsViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/11/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol NewScriptUpdatedDataProtocol: class {
    func updateScript(script: JSON, dynamicIntForRooms: Int)
}

class ScriptCurrentRoomsViewController: UIViewController {
    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, modelRoomsConfig: ModelRoomsConfigProtocol, scriptCreator: JSON, dynamicIntForRooms: Int) {
        self.modelRoomsConfig = modelRoomsConfig
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        self.dynamicIntForRooms = dynamicIntForRooms
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    weak var delegate: NewScriptUpdatedDataProtocol?
    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    private var roomNumbersAndNames: [(key: Int, value: String)] = Array() // variable for data from request
    private var roomCurrentNumbersAndNames: [Int: [String]] = [:] // variable for loading curent rooms
    private var roomNumbers: [Int: [Int]] = [:] // intermediate variable for roomCurrentNumbersAndNames
    private var allRoomsForVC: [Int] = [] // room numbers for ScriptForRoomVC
    private var dynamicIntForRooms = 0
    private var scriptCreator: JSON = []
    private var presentationAssembly: PresentationAssemblyProtocol?
    private let cellIdentifier = String(describing: CurrentRoomsTableViewCell.self)
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: CurrentRoomsTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    @IBOutlet weak var labelDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        setupNavigationVC()
        modelRoomsConfig?.fetchRoomConfig()
        setupTableView()
        print(scriptCreator.dictionary)
//        roomSavedJsonDataLoader()
//        tableView.reloadData()
    }
    func setupNavigationVC() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newRoomsGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(showNewScriptVC))
    }
    @objc func showNewScriptVC() {
        delegate?.updateScript(script: self.scriptCreator, dynamicIntForRooms: self.dynamicIntForRooms)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func newRoomsGroup() {
        for index in 0..<scriptCreator.count - 2 {
            let json = scriptCreator["roomGroup\(index)"]["rIDs"].arrayValue
            var ints: [Int] = []
            for number in json {
                if let number = number.int {
                    ints.append(number)
                }
                roomNumbers[index] = ints
            }
            ints.removeAll()
        }
        for value in roomNumbers {
            for ints in value.value {
                self.allRoomsForVC.append(ints)
            }
        }
        if let scriptForRoomVC = presentationAssembly?.scriptForRoomViewController(scriptCreator: self.scriptCreator, roomNumbers: self.allRoomsForVC) {
            scriptForRoomVC.delegate = self
            let navigation = UINavigationController()
            navigation.viewControllers = [scriptForRoomVC]
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

// MARK: - CurrentRoomsViewController datasource
extension ScriptCurrentRoomsViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomCurrentNumbersAndNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrentRoomsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        var labelArrayString = ""
        for sections in self.roomCurrentNumbersAndNames where sections.key == indexPath.row {
            for section in sections.value {
                labelArrayString += section
                labelArrayString += "\n"
            }
            cell.configure(rooms: String(labelArrayString.dropLast(1)))
        }
        return cell
    }
}

// MARK: - CurrentRoomsViewController delegate
extension ScriptCurrentRoomsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let scriptForDaysVC = presentationAssembly?.currentDaysViewController(scriptCreator: self.scriptCreator, indexOfRooms: indexPath.row) {
            scriptForDaysVC.delegate = self
            navigationController?.pushViewController(scriptForDaysVC, animated: true)
        }
    }
}
// MARK: - ScriptForRoomProtocol delegate
extension ScriptCurrentRoomsViewController: ScriptForRoomProtocol {
    func save(rooms: [Int]) {
        if let dynamicIntForRooms = try? UserDefaults.standard.integer(forKey: "dynamicIntForRooms") {
            self.dynamicIntForRooms = dynamicIntForRooms
            self.jsonForRoomSection(rooms: rooms)
            self.numbersDictForRoomSection()
            self.indexAndNamesForRoomSection()
            self.dynamicIntForRooms += 1
            UserDefaults.standard.set(self.dynamicIntForRooms, forKey: "dynamicIntForRooms")
        } else {
            self.jsonForRoomSection(rooms: rooms)
            self.numbersDictForRoomSection()
            self.indexAndNamesForRoomSection()
            self.dynamicIntForRooms += 1
            UserDefaults.standard.set(self.dynamicIntForRooms, forKey: "dynamicIntForRooms")
        }
        self.tableView.reloadData()
    }

    func jsonForRoomSection(rooms: [Int]) {
        let json: JSON = JSON(rooms)
        scriptCreator["roomGroup\(dynamicIntForRooms)"] = JSON()
        scriptCreator["roomGroup\(dynamicIntForRooms)"]["rIDs"] = json
    }

    func numbersDictForRoomSection() {
        let json = scriptCreator["roomGroup\(dynamicIntForRooms)"]["rIDs"].arrayValue
        var ints: [Int] = []
        for number in json {
            if let number = number.int {
                ints.append(number)
            }
        }
        roomNumbers[dynamicIntForRooms] = ints
        ints.removeAll()
    }

    func indexAndNamesForRoomSection() {
        var labels: [String] = []
        if let number = roomNumbers[dynamicIntForRooms] {
            for intElement in number {
                for data in roomNumbersAndNames where intElement == data.key {
                    labels.append(data.value)
                }
                self.roomCurrentNumbersAndNames[dynamicIntForRooms] = labels
            }
            roomNumbers.removeAll()
            print(roomCurrentNumbersAndNames)
        }
    }
}

// MARK: - ModelRoomsConfigDelegate
extension ScriptCurrentRoomsViewController: ModelRoomsConfigDelegate {
    func setup(result: [Int: String]) {
        self.roomNumbersAndNames = result.sorted { $0.0 < $1.0 }
        roomSavedJsonDataLoader()
        self.tableView.reloadData()
    }
    func show1(error message: String) {
        print(message)
        self.showAlert()
    }
}

extension ScriptCurrentRoomsViewController: DaysUpdatedDataProtocol {
    func updateScript(script: JSON) {
        self.scriptCreator = script
    }
}

// MARK: - roomSavedJsonDataLoader()
extension ScriptCurrentRoomsViewController {
    func roomSavedJsonDataLoader() {
        let countElements = scriptCreator.count - 2
        for num in 0..<countElements {
            let json = scriptCreator["roomGroup\(num)"]["rIDs"].arrayValue
            var ints: [Int] = []
            for number in json {
                if let number = number.int {
                    ints.append(number)
                }
            }
            roomNumbers[num] = ints
            ints.removeAll()

            var labels: [String] = []
            if let number = roomNumbers[num] {
                for intElement in number {
                    for data in roomNumbersAndNames where intElement == data.key {
                        labels.append(data.value)
                    }
                    self.roomCurrentNumbersAndNames[num] = labels
                }
                roomNumbers.removeAll()
                print(roomCurrentNumbersAndNames)
            }
        }
    }
}
