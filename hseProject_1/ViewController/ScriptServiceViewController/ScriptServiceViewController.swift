//
//  ScriptServiceViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 11/19/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class ScriptServiceViewController: UIViewController {

    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var settingCreator: ViewCustomClass!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    private let pickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0.0, y: 300.0, width: 100.0, height: 300.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupTableView()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: ScriptServiceTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        return tableView
    }()
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: imageStack.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: settingCreator.topAnchor,constant: -15).isActive = true
    }
    
    let cellIdentifier = String(describing: ScriptServiceTableViewCell.self)
    
    static func storyboardInstance() -> ScriptServiceViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ScriptServiceViewController
    }
    @IBAction func previousStep(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ScriptServiceViewController dataSource methods
extension ScriptServiceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScriptServiceTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

// MARK: - ScriptServiceViewController delegate methods
extension ScriptServiceViewController: UITableViewDelegate {
    
}
