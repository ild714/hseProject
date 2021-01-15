//
//  ScriptForRoomViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ScriptForRoomProtocol: class {
    func save(rooms:[Int])
}

class ScriptForRoomViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssembly, modelRoomsConfig: ModelRoomsConfigProtocol, scriptCreator: JSON) {
        self.presentationAssembly = presentationAssembly
        self.modelRoomsConfig = modelRoomsConfig
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    weak var delegate: ScriptForRoomProtocol?
    private var presentationAssembly: PresentationAssemblyProtocol?
    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    private var scriptCreator: JSON?

    @IBOutlet weak var stackDescription: UIStackView!

    private var roomNumbersAndNames: [(key: Int, value: String)] = Array()
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

        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        setupTableView()
        modelRoomsConfig?.fetchRoomConfig()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveRoomsGroup))
    }

    @objc func saveRoomsGroup() {
        
        var rooms: [Int] = []
        var position = 0
        for mark in self.marks {
            
            if mark == true {
                rooms.append(self.roomNumbersAndNames[position].key)
            }
            position += 1
        }
        self.delegate?.save(rooms: rooms)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: stackDescription.bottomAnchor).isActive = true
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

// MARK: - ScriptsViewController datasource
extension ScriptForRoomViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNumbersAndNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScriptForRoomTableViewCell else {
            return UITableViewCell()
        }

        cell.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        cell.selectionStyle = .none
        cell.configure(room: roomNumbersAndNames[indexPath.row].value, markBool: marks[indexPath.row])

        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptForRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.marks[indexPath.row] == true {
                self.marks.remove(at: indexPath.row)
                self.marks.insert(false, at: indexPath.row)
        } else {
            self.marks.remove(at: indexPath.row)
            self.marks.insert(true, at: indexPath.row)
        }
        tableView.reloadData()
    }
}

// MARK: - ModelRoomsConfigDelegate
extension ScriptForRoomViewController: ModelRoomsConfigDelegate {
    func setup(result: [Int: String]) {
        self.roomNumbersAndNames = result.sorted { $0.0 < $1.0 }

        for _ in 0..<self.roomNumbersAndNames.count {
            self.marks.append(false)
        }
        self.tableView.reloadData()
    }
    func show1(error message: String) {
        print(message)
        self.showAlert()
    }
}
