//
//  MenuListController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import GoogleSignIn

class MenuListController: UITableViewController {
    var items = ["Мое устройство", "Сценарии", "Поддержка"]
    var customColor = UIColor(rgb: 0x353343)
    var userId = ""

    init(userId: String) {
        self.userId = String("User Login: \(userId.prefix(5))")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func exit() {
        GIDSignIn.sharedInstance()?.signOut()

        let signInVC = SignInViewController(rootAssembly: RootAssembly())
        signInVC.modalPresentationStyle = .fullScreen
        UserDefaults.standard.set(false, forKey: "Log_in")
        self.present(signInVC, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = customColor
        navigationController?.navigationBar.backgroundColor = customColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = self.userId
        let button = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(exit))
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = UIColor(rgb: 0xa4a4a4)
        cell.backgroundColor = customColor
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
