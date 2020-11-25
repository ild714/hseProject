//
//  ScriptForDaysViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptForDaysViewController: UIViewController {

    @IBOutlet weak var descriptionStack: UIStackView!
    @IBOutlet weak var switcherStack: UIStackView!
    
    var scripts = ["Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье"]
    var marks: [Bool] = []
    
    private let cellIdentifier = String(describing: ScriptForDaysTableViewCell.self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(UINib(nibName: String(describing: ScriptForDaysTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<8 {
            self.marks.append(false)
        }
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: switcherStack.topAnchor).isActive = true
    }
    
    static func storyboardInstance() -> ScriptForDaysViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptForDaysViewController
    }
    
    
    @IBAction func nextStep(_ sender: Any) {
        if let vc = ScriptServiceViewController.storyboardInstance(){
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func previousStep(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        print("!")
        print(marks)
        print("!")
        cell.configure(day: scripts[indexPath.row],markBool: marks[indexPath.row])
        
        return cell
    }
}

// MARK: - ScriptsViewController delegate
extension ScriptForDaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var position = 0
//        var localMarks = marks
        
//        for i in marks {
//            if i == true {
//                print("?")
        if self.marks[indexPath.row] == true {
                self.marks.remove(at: indexPath.row)
                self.marks.insert(false, at: indexPath.row)
        } else {
            self.marks.remove(at: indexPath.row)
            self.marks.insert(true, at: indexPath.row)
        }
//                print(marks)
//                print("?")
//                position+=1
//            } else {
//                self.marks.remove(at: position)
//                self.marks.insert(true, at: position)
//                position+=1
//            }
            tableView.reloadData()
//            print("?")
//            print(marks)
//            print("?")
//        }
//        print("???")
//        print(marks)
//        print("???")
    }
}
