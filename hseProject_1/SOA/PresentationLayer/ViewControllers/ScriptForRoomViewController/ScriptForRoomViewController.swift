//
//  ScriptForRoomViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScriptForRoomViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssembly, modelRoomsConfig: ModelRoomsConfigProtocol,scriptCreator: ScriptCreator) {
        self.presentationAssembly = presentationAssembly
        self.modelRoomsConfig = modelRoomsConfig
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var presentationAssembly: PresentationAssemblyProtocol?
    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    private var scriptCreator: ScriptCreator?
    
    @IBOutlet weak var titleCurrentRoom: UILabel!
    @IBOutlet weak var stackDescription: UIStackView!
    @IBOutlet weak var stackSwitcher: UIStackView!

    private var roomNumbersAndNames: [Int: String] = [:]
    private var marks: [Bool] = []

    private let cellIdentifier = String(describing: ScriptForRoomTableViewCell.self)

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: ScriptForRoomTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let roomGroup = RoomGroopCreator(rIDs: [0], dayGroup0: nil, dayGroup1: nil)
        self.scriptCreator?.roomGroup0 = roomGroup
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        setupTableView()
        modelRoomsConfig?.fetchRoomConfig()
    }

    func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: stackDescription.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: stackSwitcher.topAnchor).isActive = true
    }

    func showAlert() {
        let alertVC = UIAlertController(title: "Ошибка подключения к wi-fi", message: "Включите wi-fi и перезапустите приложение", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }

    @IBAction func previousStep(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextStep(_ sender: Any) {
        if let script = self.scriptCreator {
            if let scriptForDaysVC = presentationAssembly?.scriptForDaysViewController(scriptCreator: script) {
                navigationController?.pushViewController(scriptForDaysVC, animated: true)
            }
        }
    }
}

// MARK: - ScriptsViewController datasource
extension ScriptForRoomViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNumbersAndNames.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScriptForRoomTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.configure(room: roomNumbersAndNames[indexPath.row + 2] ?? "No other rooms", markBool: marks[indexPath.row])

        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptForRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.marks[indexPath.row] == true {
                self.marks.remove(at: indexPath.row)
                self.marks.insert(false, at: indexPath.row)
//            self.scriptCreator?.roomGroup0?.rIDs = [47,48]
            self.scriptCreator?.roomGroup0?.rIDs = [0]
            var position = 1
            for mark in self.marks {
                if mark == true {
                    self.scriptCreator?.roomGroup0?.rIDs.append(position)
                }
                position += 1
            }

        } else {
            self.marks.remove(at: indexPath.row)
            self.marks.insert(true, at: indexPath.row)

            self.scriptCreator?.roomGroup0?.rIDs = [0]
            var position = 1
            for mark in self.marks {
                if mark == true {
                    self.scriptCreator?.roomGroup0?.rIDs.append(position)
                }
                position += 1
            }
        }
        tableView.reloadData()
    }
}

// MARK: - ModelRoomsConfigDelegate
extension ScriptForRoomViewController: ModelRoomsConfigDelegate {
    func setup(result: [Int: String]) {
        self.roomNumbersAndNames = result
        if let title = self.roomNumbersAndNames[1] {
            self.titleCurrentRoom.text = "Зададим сценарий для комнаты \(title)"
        }

        for _ in 0..<self.roomNumbersAndNames.count - 1 {
            self.marks.append(false)
        }
        self.tableView.reloadData()
    }
    func show1(error message: String) {
        print(message)
        self.showAlert()
    }
}
