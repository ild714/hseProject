//
//  ScriptForRoomViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptForRoomViewController: UIViewController {

    @IBOutlet weak var stackDescription: UIStackView!
    @IBOutlet weak var stackSwitcher: UIStackView!
    
    var scripts = ["Гостиная"]
    var marks = [false]
    
    private let cellIdentifier = String(describing: ScriptForRoomTableViewCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: ScriptForRoomTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: stackDescription.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: stackSwitcher.topAnchor).isActive = true
    }
    
    static func storyboardInstance() -> ScriptForRoomViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptForRoomViewController
    }
    
    @IBAction func previousStep(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nextStep(_ sender: Any) {
        if let vc = ScriptForDaysViewController.storyboardInstance(){
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - ScriptsViewController datasource
extension ScriptForRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScriptForRoomTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configure(room: scripts[indexPath.row],markBool: marks[indexPath.row])
        
        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptForRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.marks = []
        for i in 0...scripts.count{
            if i == indexPath.row{
                marks.append(true)
            }else {
                marks.append(false)
            }
        }
        tableView.reloadData()
    }
}
