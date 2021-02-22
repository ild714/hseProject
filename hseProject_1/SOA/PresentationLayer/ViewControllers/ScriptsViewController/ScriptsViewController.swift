//
//  ScriptsViewController1.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScriptsViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol) {
        self.presentationAssembly = presentationAssembly
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    let headerTitles = ["Заполненные сценарии", "Черновик"]
    private var presentationAssembly: PresentationAssemblyProtocol?
    var safeArea: UILayoutGuide!
    var marks: [Bool] = []
    var scriptsDict: [Int: String] = [:]
    var sortedDictValues: [String] = []
    var currentScript = 0
    var arrayDict: [(key: Int, value: String)]?
    static func storyboardInstance() -> ScriptsViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptsViewController
    }

    private let cellIdentifier = String(describing: CustomTableViewCell.self)

    override func viewDidLoad() {
//        userDefaultsCleaner()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.loadScripts(group: group)
        }
        group.notify(queue: .main) {
            self.sortDict()
            self.setupTableView()
        }
        title = "Сценарии"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 20)!]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        self.navigationController?.toolbar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newScripts))
    }
    override func viewWillDisappear(_ animated: Bool) {
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            if key.contains("room") || key.contains("Scripts") {
//                print(key)
//                defaults.removeObject(forKey: key)
//            }
//        }
        tableView.reloadData()
    }
    func userDefaultsCleaner() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.contains("room") || key.contains("Scripts") || key.contains("dynamicIntForRooms") {
                print(key)
                defaults.removeObject(forKey: key)
            }
        }
    }
    func loadScripts(group: DispatchGroup) {
        let loadScripts = NetworkScriptLoad()
        loadScripts.getDataScripts { (result: Result<[String: JSON], NetworkSensorError>) in
            switch result {
            case .success(let result):
                for data in result {
                    if data.key == "cur" {
                        if let valueInt = data.value.int {
                            self.currentScript = valueInt
                        }
                    } else {
                        if let intData = Int(data.key) {
                            self.scriptsDict[intData] = data.value.string
                        }
                    }
                }
                print(self.scriptsDict)
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func sortDict() {
        arrayDict = Array(self.scriptsDict)
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        return tableView
    }()

    func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        safeArea = view.layoutMarginsGuide

        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }

    @objc func newScripts() {
        let count = UserDefaults.standard.integer(forKey: "JSONCount")
        if count == 1 {
            self.alert(title: "Остался незаполненный черновик", message: "Завершите заполнение черновика")
        } else {
            userDefaultsCleaner()
            if let newScriptVC = presentationAssembly?.newScriptViewController(scriptCreator: JSON()) {
                newScriptVC.delegate = self
                newScriptVC.notNewScript = false
                navigationController?.pushViewController(newScriptVC, animated: true)
                UserDefaults.standard.set(0 + UserDefaults.standard.integer(forKey: "LastJSON"), forKey: "CurrentJSON")
            }
        }
    }
    func alert(title: String, message: String) {
        let vcAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vcAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(vcAlert, animated: true)
    }
}

// MARK: - ScriptsViewController datasource
extension ScriptsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayDict?.count ?? 0
        } else if section == 1 {
            if let countJson = try? UserDefaults.standard.integer(forKey: "JSONCount") {
                return countJson
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }

            cell.selectionStyle = .none
            arrayDict = arrayDict?.sorted(by: { $0.0 < $1.0 })
            if let result = arrayDict?[indexPath.row] {
                cell.configure(scriptText: result, selected: currentScript)
            }

            return cell
        } else if indexPath.section == 1 {
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            var stringScripts: [String] = []
            dictionary.keys.forEach { key in
                if key.contains("Json") {
                    print(key)
                    stringScripts.append(key)
                }
            }
            print(stringScripts, "+++")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            stringScripts = stringScripts.sorted()
            cell.selectionStyle = .none

            let jsonData = UserDefaults.standard.object(forKey: stringScripts[indexPath.row]) as? Data
            if let jsonData = jsonData {
                let json = try? JSON(data: jsonData)
                print(json, "!!!")
                cell.configureJson(scriptText: json?["name"].string ?? "No label text", index: indexPath.row)
            }

            cell.backgroundColor = .black

            return cell
        }
        return UITableViewCell()
    }

}

// MARK: - ScriptsViewController delegate
extension ScriptsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.marks = []
            let networkSetScript = NetworkSetScript()
            if let key = arrayDict?[indexPath.row].key {
                networkSetScript.sentDataScript(scId: key)
                self.currentScript = key
            }
            tableView.reloadData()
        } else {
            let jsonData = UserDefaults.standard.object(forKey: "Json\(indexPath.row+UserDefaults.standard.integer(forKey: "LastJSON"))") as? Data
            if let jsonData = jsonData {
                if let json = try? JSON(data: jsonData) {
                    if let newScriptVC = presentationAssembly?.newScriptViewController(scriptCreator: json) {
                        newScriptVC.delegate = self
//                        print(indexPath.row + UserDefaults.standard.integer(forKey: "LastJSON"), "fff")
                        print(UserDefaults.standard.integer(forKey: "LastJSON"))
                        UserDefaults.standard.set(indexPath.row + UserDefaults.standard.integer(forKey: "LastJSON"), forKey: "CurrentJSON")
                        navigationController?.pushViewController(newScriptVC, animated: true)
                    }
                    print(json, "!!!")
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if editingStyle == .delete {

                let networkSetScript = DeleteScript()
                if let key = arrayDict?[indexPath.row].key {
                    networkSetScript.sentDataScript(scId: key)
                    arrayDict?.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        if indexPath.section == 1 {
            if editingStyle == .delete {
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    if key.contains("Json\(indexPath.row+UserDefaults.standard.integer(forKey: "LastJSON"))") {
                        print(key, "---")
                        defaults.removeObject(forKey: key)
                        let count = UserDefaults.standard.integer(forKey: "JSONCount")
                        UserDefaults.standard.set(count-1, forKey: "JSONCount")
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
}

extension ScriptsViewController: UpdateScripts {
    func update() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.loadScripts(group: group)
        }
        group.notify(queue: .main) {
            self.sortDict()
            self.tableView.reloadData()
        }
    }
}
