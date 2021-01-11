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
    private var presentationAssembly: PresentationAssemblyProtocol?
    var safeArea: UILayoutGuide!
//    var scripts = ["На работе", "Отпуск", "Карантин"]
    var marks : [Bool] = []
    var scriptsDict: [Int:String] = [:]
    var sortedDictValues: [String] = []
    var currentScript = 0
    static func storyboardInstance() -> ScriptsViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptsViewController
    }

    private let cellIdentifier = String(describing: CustomTableViewCell.self)

    override func viewDidLoad() {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.loadScripts(group: group)
        }
        group.notify(queue: .main) {
            print(self.scriptsDict)
            self.createCheckList()
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

    func loadScripts(group: DispatchGroup) {
        let loadScripts = NetworkScriptLoad()
        loadScripts.getDataScripts() { (result: Result<[String: JSON], NetworkSensorError>) in
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
                group.leave()
                print(self.scriptsDict)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createCheckList() {
        print(Array(self.scriptsDict.keys.sorted()))
        for scriptKey in Array(self.scriptsDict.keys.sorted()) {
            if scriptKey == self.currentScript {
                self.marks.append(true)
            } else {
                self.marks.append(false)
            }
        }
    }
    
    func sortDict() {
        sortedDictValues = Array(self.scriptsDict.values.sorted())
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
        if let newScriptVC = presentationAssembly?.newScriptViewController() {
            navigationController?.pushViewController(newScriptVC, animated: true)
        }
    }

}

// MARK: - ScriptsViewController datasource
extension ScriptsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedDictValues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        print(sortedDictValues)
        cell.configure(scriptText: sortedDictValues[indexPath.row], mark: marks[indexPath.row])

        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.marks = []

        for scriptCount in 0...sortedDictValues.count {
            if scriptCount == indexPath.row {
                marks.append(true)
            } else {
                marks.append(false)
            }
        }
        tableView.reloadData()
    }
}
