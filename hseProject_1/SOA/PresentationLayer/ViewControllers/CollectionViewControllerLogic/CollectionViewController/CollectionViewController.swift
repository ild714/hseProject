//
//  CollectionViewController.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenu
import GoogleSignIn

class CollectionViewController: UIViewController, ToolBarWithPageControllProtocol {
    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, userId: String, modelRoomsConfig: ModelRoomsConfigProtocol, modelRoomDatchik: ModelAppDatchikProtocol) {
        self.presentationAssembly = presentationAssembly
        self.userId = userId
        self.modelRoomsConfig = modelRoomsConfig
        self.modelRoomDatchik = modelRoomDatchik
//        self.modelAimData = modelAimData
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var presentationAssembly: PresentationAssemblyProtocol?
    private var roomNumbersAndNames: [Int: String] = [:]
    private var resultDatchik: [String: JSON] = [:]
    private var aimRoomScripts: [Int: AimRoomScript] = [:]
    private var modelAimData: ModelAimDataProtocol?
    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    private var modelRoomDatchik: ModelAppDatchikProtocol?
    private var menu: SideMenuNavigationController?
    private var userId = ""
    private var curentVC: Int = 0
    private var safeArea: UILayoutGuide!
    private let cellIdentifier = String(describing: CustomCollectionViewCell.self)
    private var errorCount = 0

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: String(describing: CustomCollectionViewCell.self), bundle: nil ), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    var launchVCMain: LaunchScreenViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

//        if UserDefaults.standard.bool(forKey: "Log_in") {
//            if let launchVC = LaunchScreenViewController.storyboardInstance() {
//                launchVC.modalPresentationStyle = .overFullScreen
//                self.navigationController?.present(launchVC, animated: false, completion: nil)
//                launchVCMain = launchVC
//            }
//        } else {
//            UserDefaults.standard.set(true, forKey: "Log_in")
//        }
        title = "Все комнаты"
        self.createPageControll()
        self.createGestureRecognizer()
        self.createMenuForNavigationController()
        self.createButtonForNavigationController()
        self.setColorForNavigationController()
        self.modelRoomsConfig?.fetchRoomConfig()
        self.loadAppDatchik()
//        self.modelAimData?.fetchAimData()
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.modelAimData?.fetchAimData()
    }
    func loadAppDatchik() {
        modelRoomDatchik?.fetchAppDatchik(type: .current) { (result: [String: JSON]) in
            self.resultDatchik = result
            self.collectionView.reloadData()
        }
    }
    func showAlert() {
        let alertVC = UIAlertController(title: "Ошибка подключения к wi-fi", message: "Включите wi-fi и перезапустите приложение", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
    func createPageControll() {
        self.createPageControl(viewController: self, number: self.curentVC, allAmountOfPages: self.roomNumbersAndNames.count + 1)
    }
    func createGestureRecognizer() {
        if self.curentVC == 0 {
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeFirst(sender:)))
            leftSwipe.direction = .left
            let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeFirst(sender:)))
            upSwipe.direction = .up

            self.view.addGestureRecognizer(upSwipe)
            self.view.addGestureRecognizer(leftSwipe)
        }
    }
    func createMenuForNavigationController() {
        if let presentationAssembly = self.presentationAssembly {
            menu = SideMenuNavigationController(rootViewController: MenuListController(userId: self.userId, presentationAssembly: presentationAssembly, collectionSelf: self, roomsController: nil))
            menu?.leftSide = true
//            menu?.enableSwipeToDismissGesture = false
        }
    }
    func createButtonForNavigationController() {
        let button = UIBarButtonItem(image: UIImage(named: "menu4"), style: .plain, target: self, action: #selector(didTapMenu))
        button.tintColor = .white
        navigationItem.leftBarButtonItem = button
    }
    @objc func didTapMenu() {
        if let menu = menu {
            present(menu, animated: true)
        }
    }
    func setColorForNavigationController() {
        self.navigationController?.navigationBar.setGradientBackground(
            colors: [UIColor.init(red: 41/255.0, green: 114/255.0, blue: 237/255.0, alpha: 1),
                     UIColor.init(red: 41/255.0, green: 252/255.0, blue: 237/255.0, alpha: 1)],
            startPoint: .topLeft,
            endPoint: .bottomRight)
    }
    @objc func handleSwipeFirst(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .left:
                if Array(self.roomNumbersAndNames.keys.sorted()).count > 0 {
                    if let roomsVC = presentationAssembly?.roomsViewController(curentVC: 1,
                                                                               roomNumbersAndNames: self.roomNumbersAndNames,
                                                                               resultDatchik: self.resultDatchik,
                                                                               currentRoomData:
                                                                                CurrentRoomData(result: resultDatchik, curentRoom: Array(self.roomNumbersAndNames.keys.sorted())[self.curentVC])) {
                        navigationController?.pushViewController(roomsVC, animated: true)
                    }
                }
            case .up:
                if let scriptsVC = self.presentationAssembly?.scriptsViewController() {
                    scriptsVC.delegate = self
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [scriptsVC]
                    present(navigationController, animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }

    override func loadView() {
        super.loadView()

        safeArea = view.layoutMarginsGuide
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(collectionView)

        collectionView.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomNumbersAndNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomCollectionViewCell ?? CustomCollectionViewCell()

        print("cuurent")
        let keyId = Array(self.roomNumbersAndNames.keys.sorted())[indexPath.row]
            let currentRoomData = CurrentRoomData(result: resultDatchik, curentRoom: Array(self.roomNumbersAndNames.keys.sorted())[indexPath.row])
        cell.configure(currentRoomText: self.roomNumbersAndNames[keyId] ?? "No value", currentRoom: currentRoomData, launchVC: self.launchVCMain)

//        if let launchVCMain = launchVCMain {
//            launchVCMain.dismiss(animated: true, completion: nil)
//        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let roomsVC = presentationAssembly?.roomsViewController(curentVC: indexPath.row + 1,
                                                                   roomNumbersAndNames: self.roomNumbersAndNames,
                                                                   resultDatchik: self.resultDatchik,
                                                                   currentRoomData: CurrentRoomData(result: resultDatchik, curentRoom: Array(self.roomNumbersAndNames.keys.sorted())[indexPath.row])) {
            navigationController?.pushViewController(roomsVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 20
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

// MARK: - ModelRoomsConfigDelegate
extension CollectionViewController: ModelRoomsConfigDelegate {
    // Sort inputted dictionary with keys alphabetically.
//    func sortWithKeys(_ dict: [Int: String]) -> [Int: String] {
//        let sorted = dict.sorted(by: { $0.key > $1.key })
//        var newDict: [Int: String] = [:]
//        for sortedDict in sorted {
//            newDict[sortedDict.key] = sortedDict.value
//        }
//        print("reess")
//        print(newDict)
//        return newDict
//    }
    
    func setup(result: [Int: String]) {
        
        self.roomNumbersAndNames = result
        UserDefaults.standard.set(roomNumbersAndNames.count, forKey: "RoomsCount")
        self.createPageControll()
        self.collectionView.reloadData()
    }
    func show1(error message: String) {
        print(message.description)
        if errorCount < 4 {
            self.viewDidLoad()
            errorCount += 1
        } else {
//            self.showAlert()
        }
    }
}

// MARK: - ModelAppDatchikDelegate
extension CollectionViewController: ModelAppDatchikDelegate {
    func show2(error message: String) {
        print(message.description)
        if errorCount < 4 {
            self.viewDidLoad()
            errorCount += 1
        } else {
//            self.showAlert()
        }
    }
}

// MARK: - ModelAimDataDelegate
extension CollectionViewController: ModelAimDataDelegate {
    func setup(result: [Int: AimRoomScript]) {
        self.aimRoomScripts = result
    }

    func show3(error message: String) {
        print(message.description)
        if errorCount < 4 {
            self.viewDidLoad()
            errorCount += 1
        } else {
//            self.showAlert()
        }
    }
}

// MARK: - CollectionUpdate
extension CollectionViewController: CollectionUpdate {
    func update() {
        self.modelAimData?.fetchAimData()
        self.menu?.dismiss(animated: true, completion: nil)
    }
}
