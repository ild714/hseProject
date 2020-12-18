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
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private var presentationAssembly: PresentationAssemblyProtocol?
    private var curentVC: Int = 0
    private var roomNumbersAndNames: [Int: String] = [:]
    private var safeArea: UILayoutGuide!
    private var menu: SideMenuNavigationController?
    private var userId = ""
    private let cellIdentifier = String(describing: CustomCollectionViewCell.self)
    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    private var modelRoomDatchik: ModelAppDatchikProtocol?

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

    @objc func didTapMenu() {
        if let menu = menu {
            present(menu, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Все комнаты"

        self.createPageControll()
        self.createGestureRecognizer()
        self.createMenuForNavigationController()
        self.createButtonForNavigationController()
        self.setColorForNavigationController()
        modelRoomsConfig?.fetchRoomConfig()
    }
    func showAlert() {
        let alertVC = UIAlertController(title: "Ошибка подключения к wi-fi", message: "Включите wi-fi и перезапустите приложение", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
    func createPageControll() {
        self.createPageControl(viewController: self, number: self.curentVC, allAmountOfPages: self.roomNumbersAndNames.count + 1)
        self.collectionView.reloadData()
    }
    func createGestureRecognizer() {
        if self.curentVC == 0 {
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeFirst(sender:)))
            leftSwipe.direction = .left
            self.view.addGestureRecognizer(leftSwipe)
        }
    }
    func createMenuForNavigationController() {
        menu = SideMenuNavigationController(rootViewController: MenuListController(userId: self.userId))
        menu?.leftSide = true
    }
    func createButtonForNavigationController() {
        let button = UIBarButtonItem(image: UIImage(named: "menu4"), style: .plain, target: self, action: #selector(didTapMenu))
        button.tintColor = .white
        navigationItem.leftBarButtonItem = button
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
                if let roomsVC = RoomsViewController.storyboardInstance() {
                    navigationController?.pushViewController(roomsVC, animated: true)
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

    static func storyboardInstance() -> CollectionViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? CollectionViewController
    }

}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomNumbersAndNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomCollectionViewCell ?? CustomCollectionViewCell()

        modelRoomDatchik?.fetchAppDatchik(type: .current) { (result) in

            let currentRoomData = CurrentRoomData(result: result, curentRoom: indexPath.row + 1)
            cell.configure(currentRoomText: self.roomNumbersAndNames[indexPath.row + 1] ?? "", currentRoom: currentRoomData)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let roomsVC = RoomsViewController.storyboardInstance() {
            roomsVC.curentRoom = indexPath.row + 1
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
    func setup(result: [Int: String]) {
        self.roomNumbersAndNames = result
        self.createPageControll()
    }
    func show1(error message: String) {
        print(message)
        self.showAlert()
    }
}

// MARK: - ModelAppDatchikDelegate
extension CollectionViewController: ModelAppDatchikDelegate {
    func show2(error message: String) {
        print(message)
        self.showAlert()
    }
}
