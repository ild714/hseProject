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
    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, scriptCreator: JSON) {
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var allRoomsForVC: [Int] = []
    var roomNumbers: [Int:[Int]] = [:]
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
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newRoomsGroup))
    }
    @objc func newRoomsGroup() {
        for index in 0..<dynamicInt {
            print(scriptCreator["roomGroup\(index)"]["rIDs"].arrayValue)
            
            let json = scriptCreator["roomGroup\(index)"]["rIDs"].arrayValue
            for number in json {
                var ints : [Int] = []
                if let number = number.int {
                    ints.append(number)
                }
                roomNumbers[index] = ints
                ints.removeAll()
            }
            
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
//            navigationController?.pushViewController(scriptForRoomVC, animated: true)
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
}

// MARK: - CurrentRoomsViewController datasource
extension ScriptCurrentRoomsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNumbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrentRoomsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        cell.configure(rooms: "test")

        return cell
    }
}

// MARK: - CurrentRoomsViewController delegate
extension ScriptCurrentRoomsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("!!!")
        print(self.scriptCreator)
    }
}
// MARK: - ScriptForRoomProtocol delegate
extension ScriptCurrentRoomsViewController: ScriptForRoomProtocol {
    func save(rooms: [Int]) {
//        print(rooms)
        let json: JSON = JSON(rooms)
        scriptCreator["roomGroup\(dynamicInt)"] = JSON()
        scriptCreator["roomGroup\(dynamicInt)"]["rIDs"] = json
        dynamicInt += 1
        
//        print(self.scriptCreator)
    }
}
