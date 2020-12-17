//
//  ScriptsViewController1.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptsViewController: UIViewController {

    var safeArea: UILayoutGuide!
    var scripts = ["На работе", "На улице жарко", "Отпуск", "Карантин"]
    var marks = [false, true, false, false]

    static func storyboardInstance() -> ScriptsViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptsViewController
    }

    private let cellIdentifier = String(describing: CustomTableViewCell.self)

    override func viewDidLoad() {
        setupTableView()

        title = "Сценарии"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 20)!]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        self.navigationController?.toolbar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(newScripts))
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
        if let newScriptVC = NewScriptViewController.storyboardInstance() {
            navigationController?.pushViewController(newScriptVC, animated: true)
        }
    }

}

// MARK: - ScriptsViewController datasource
extension ScriptsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.configure(scriptText: scripts[indexPath.row], mark: marks[indexPath.row])

        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.marks = []

        for scriptCount in 0...scripts.count {
            if scriptCount == indexPath.row {
                marks.append(true)
            } else {
                marks.append(false)
            }
        }
        tableView.reloadData()
    }
}
