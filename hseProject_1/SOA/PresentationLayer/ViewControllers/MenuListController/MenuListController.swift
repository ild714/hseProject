//
//  MenuListController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/17/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import GoogleSignIn
import KeychainAccess

class MenuListController: UITableViewController {
    var items = ["Сценарии"]
    var customColor = UIColor(rgb: 0x353343)
    var userId = ""
    var collection: CollectionViewController?
    var roomsController: RoomsViewController?

    init(userId: String, presentationAssembly: PresentationAssemblyProtocol, collectionSelf: CollectionViewController?, roomsController: RoomsViewController?) {
        self.presentationAssembly = presentationAssembly
        self.userId = String("User Login:\n \(userId)")
        self.collection = collectionSelf
        self.roomsController = roomsController
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var presentationAssembly: PresentationAssemblyProtocol?

    @objc func exit() {
        GIDSignIn.sharedInstance()?.signOut()

//        let signInVC = SignInViewController(rootAssembly: RootAssembly())
        let signInVC = SignInViewController.storyboardInstance()
        signInVC?.rootAssembly = RootAssembly()
        signInVC?.modalPresentationStyle = .fullScreen
        UserDefaults.standard.set(false, forKey: "Log_in")
        if let signInVC = signInVC {
            self.present(signInVC, animated: true, completion: nil)
        }
//        let keychain = Keychain(service: "com.nigmetzyanov.IndoorClimateControlSystems")
//        keychain["email"] = nil

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setColors()
        multipleTitle()
        setRightButton()
    }

    func setRightButton() {
        let button = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(exit))
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }
    func setColors() {
        tableView.backgroundColor = customColor
        navigationController?.navigationBar.backgroundColor = customColor
    }
    func multipleTitle() {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 11.0)
        label.textAlignment = .center
        label.textColor = .black
        label.text = self.userId
        self.navigationItem.titleView = label
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
        if let scriptsVC = presentationAssembly?.scriptsViewController() {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [scriptsVC]
//            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            scriptsVC.delegate = self.collection
            scriptsVC.delegateRoomsView = self.roomsController
            present(navigationController, animated: true, completion: nil)
        }
    }
}
