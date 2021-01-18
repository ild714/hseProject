//
//  CurrentRoomsViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 1/11/21.
//  Copyright © 2021 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScriptCurrentRoomsViewController: UIViewController {
    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, modelRoomsConfig: ModelRoomsConfigProtocol, scriptCreator: JSON) {
        self.modelRoomsConfig = modelRoomsConfig
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    var indexForSections = 0
    private var roomNumbersAndNames: [(key: Int, value: String)] = Array()
    var roomCurrentNumbersAndNames: [Int: [String]] = [:]
    var allRoomsForVC: [Int] = []
    var roomNumbers: [Int: [Int]] = [:]
    var dynamicInt = 0
    var dynamicString = ""
    var scriptCreator: JSON = []
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newRoomsGroup))
        modelRoomsConfig?.fetchRoomConfig()
        setupTableView()
    }
    @objc func newRoomsGroup() {
        for index in 0..<dynamicInt {
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


        for sections in self.roomCurrentNumbersAndNames {
            if sections.key == indexPath.row {
                for section in sections.value {
                    labelArrayString += section
                    labelArrayString += "\n"
                }
                print(labelArrayString)
                cell.configure(rooms: labelArrayString)
            } else {
            }
        }

        return cell
    }
}

// MARK: - CurrentRoomsViewController delegate
extension ScriptCurrentRoomsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(self.scriptCreator)
        if let scriptForDaysVC = presentationAssembly?.currentDaysViewController(scriptCreator: self.scriptCreator) {
            scriptForDaysVC.previousNumber = indexPath.row
            navigationController?.pushViewController(scriptForDaysVC, animated: true)
        }
    }
}
// MARK: - ScriptForRoomProtocol delegate
extension ScriptCurrentRoomsViewController: ScriptForRoomProtocol {
    func save(rooms: [Int]) {

        self.jsonForRoomSection(rooms: rooms)

        self.numbersDictForRoomSection()
        self.indexAndNamesForRoomSection()
        dynamicInt += 1
        self.tableView.reloadData()
    }

    func jsonForRoomSection(rooms: [Int]) {
        let json: JSON = JSON(rooms)
        scriptCreator["roomGroup\(dynamicInt)"] = JSON()
        scriptCreator["roomGroup\(dynamicInt)"]["rIDs"] = json

    }

    func numbersDictForRoomSection() {
        let json = scriptCreator["roomGroup\(dynamicInt)"]["rIDs"].arrayValue
        var ints: [Int] = []
        for number in json {
            if let number = number.int {
                ints.append(number)
            }
        }
        roomNumbers[dynamicInt] = ints
        ints.removeAll()
    }

    func indexAndNamesForRoomSection() {
        var labels: [String] = []
        if let number = roomNumbers[dynamicInt] {
            for intElement in number {
                for data in roomNumbersAndNames {
                    if intElement == data.key {
                        labels.append(data.value)
                    }
                }
                self.roomCurrentNumbersAndNames[dynamicInt] = labels
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
    }
    func show1(error message: String) {
        print(message)
        self.showAlert()
    }
}
