//
//  ScriptForDaysViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ScriptForDaysProtocol: class {
    func save(daysString: [String])
}

class ScriptForDaysViewController: UIViewController {

    init?(coder: NSCoder, presentationAssembly: PresentationAssembly, scriptCreator: JSON, daysString: [String]) {
        self.presentationAssembly = presentationAssembly
        self.scriptCreator = scriptCreator
        self.daysString = daysString
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    var emptyVC = false
    weak var delegate: ScriptForDaysProtocol?
    private var daysString: [String] = []
    private var presentationAssembly: PresentationAssemblyProtocol?
    private var scriptCreator: JSON?
    @IBOutlet weak var descriptionStack: UIStackView!

    var scripts = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    var marks: [Bool] = []

    private let cellIdentifier = String(describing: ScriptForDaysTableViewCell.self)

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: ScriptForDaysTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        for day in daysString {
            if let index = scripts.firstIndex(of: day) {
                scripts.remove(at: index)
            }
        }
        if scripts.count == 0 {
            self.emptyVC = true
        }
        daysString = []
        for _ in 0..<scripts.count {
            self.marks.append(false)
        }
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveDaysGroup))
    }
    @objc func saveDaysGroup() {
        if emptyVC {
            self.dismiss(animated: true, completion: nil)
        } else {
            var index = 0
            for mark in marks {
                if mark {
                    self.daysString.append(scripts[index])
                }
                index += 1
            }

            if self.daysString.count == 0 {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.delegate?.save(daysString: self.daysString )
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    static func storyboardInstance() -> ScriptForDaysViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptForDaysViewController
    }

}

// MARK: - ScriptsViewController datasource
extension ScriptForDaysViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScriptForDaysTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.configure(day: scripts[indexPath.row], markBool: marks[indexPath.row])

        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptForDaysViewController: UITableViewDelegate {
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
