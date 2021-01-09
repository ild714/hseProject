//
//  ViewController.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenu

class RoomsViewController: UIViewController, ToolBarWithPageControllProtocol {

    init?(coder: NSCoder, presentationAssembly: PresentationAssemblyProtocol, userId: String, modelRoomsConfig: ModelRoomsConfigProtocol, modelRoomDatchik: ModelAppDatchikProtocol, curentVC: Int) {
        self.presentationAssembly = presentationAssembly
        self.userId = userId
        self.modelRoomsConfig = modelRoomsConfig
        self.modelRoomDatchik = modelRoomDatchik
        self.curentVC = curentVC
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var presentationAssembly: PresentationAssemblyProtocol?
    private var menu: SideMenuNavigationController?
    private var userId = ""
    private var modelRoomsConfig: ModelRoomsConfigProtocol?
    private var modelRoomDatchik: ModelAppDatchikProtocol?
    private var curentVC: Int = 1
    private var roomNumbersAndNames: [Int: String] = [:]
    private var switchRoom = false

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewCO2: UIStackView!
    @IBOutlet weak var stackViewWet: UIStackView!
    @IBOutlet weak var stackViewTemperature: UIStackView!

    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var modOfCurrentTemperature: UILabel!
    @IBOutlet weak var aimTemperature: LabelRightSideCustomClass!

    @IBOutlet weak var currentWet: UILabel!
    @IBOutlet weak var aimWet: LabelRightSideCustomClass!
    @IBOutlet weak var modOfTheCurrentWet: UILabel!

    @IBOutlet weak var currentGas: UILabel!
    @IBOutlet weak var aimGas: LabelRightSideCustomClass!
    @IBOutlet weak var ppmLabel: UILabel!

    @IBOutlet weak var peopleInRoom: LabelRightSideCustomClass!

    @IBAction func minusTemperature(_ sender: Any) {
        self.aimTemperature.text = TemperatureConfig.minus(string: aimTemperature.text ?? "20") ?? "50℃"
    }

    @IBAction func plusTemperature(_ sender: Any) {
        self.aimTemperature.text = TemperatureConfig.plus(string: aimTemperature.text ?? "20") ?? "0℃"
    }

    @IBAction func ventilateRoom(_ sender: Any) {
        NetworkTemperatureResponse.getResponse(with: "https://vc-srvr.ru/app/scen/get_cur?did=40RRTM304FCdd5M80ods&rid=1") {  (result: Result<String, NetworkTemperatureError>) in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                navigationController?.popViewController(animated: true)
            case .left:
                if let roomsVC = presentationAssembly?.roomsViewController(curentVC: self.curentVC + 1) {
                    navigationController?.pushViewController(roomsVC, animated: true)
                }
            case .up:
                if let scriptsVC = self.presentationAssembly?.scriptsViewController() {
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [scriptsVC]
                    present(navigationController, animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }

    @objc func handleSwipeLast(sender: UISwipeGestureRecognizer) {
           if sender.state == .ended {
               switch sender.direction {
               case .right:
                   navigationController?.popViewController(animated: true)
               case .up:
                    print("up")
                if let scriptsVC = self.presentationAssembly?.scriptsViewController() {
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [scriptsVC]
                    present(navigationController, animated: true, completion: nil)
                }
               default:
                   break
               }
           }
       }

    @objc func didTapMenu() {
        if let menu = menu {
            present(menu, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMenuForNavigationController()
        self.createButtonForNavigationController()
        self.addWhiteColorForStackViews()
        self.setGradientForNavigation()
        self.deleteBackButtonFromNavigation()
        self.startAnimation()
        self.modelRoomsConfig?.fetchRoomConfig()
        self.setupCurrentAppDatchik()
        self.setupCurrentAimAppDatchik()
    }
    func createMenuForNavigationController() {
        if let presentationAssembly = self.presentationAssembly {
            menu = SideMenuNavigationController(rootViewController: MenuListController(userId: self.userId, presentationAssembly: presentationAssembly))
            menu?.leftSide = true
        }
    }

    func createButtonForNavigationController() {
        let button = UIBarButtonItem(image: UIImage(named: "menu4"), style: .plain, target: self, action: #selector(didTapMenu))
        button.tintColor = .white
        navigationItem.leftBarButtonItem = button
    }

    func addWhiteColorForStackViews() {
        stackView.backColor(stackView: stackView)
        stackViewCO2.backColor(stackView: stackViewCO2)
        stackViewWet.backColor(stackView: stackViewWet)
        stackViewTemperature.backColor(stackView: stackViewTemperature)
    }

    func setGradientForNavigation() {
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.init(rgb: 0x5b80ea), UIColor.init(rgb: 0x37b5dd)], startPoint: .topLeft, endPoint: .bottomRight)
    }

    func deleteBackButtonFromNavigation() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    func setTitleAndPageControll() {
        self.title = Array(self.roomNumbersAndNames.values.sorted())[self.curentVC - 1]
        self.createPageControll()
    }
    func setDefaultValuesForAimParamtrs() {
        self.aimTemperature.text = "-"
        self.aimWet.text = "-"
        self.aimGas.text = "-"
        ActivityIndicator.stopAnimating(views: [self.aimTemperature, self.aimWet, self.aimGas])
    }
    func showAlert() {
        let alertVC = UIAlertController(title: "Ошибка подключения к wi-fi", message: "Включите wi-fi и перезапустите приложение", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }

    func createPageControll() {
        self.createPageControl(viewController: self, number: self.curentVC, allAmountOfPages: self.roomNumbersAndNames.count + 1)
    }
    func startAnimation() {
        ActivityIndicator.animateActivity(
            views: [ViewSpecialAndGeneral(view: self.aimWet, type: .special),
                    ViewSpecialAndGeneral(view: self.currentGas),
                    ViewSpecialAndGeneral(view: self.currentWet, type: .special),
                    ViewSpecialAndGeneral(view: self.peopleInRoom),
                    ViewSpecialAndGeneral(view: self.aimGas),
                    ViewSpecialAndGeneral(view: self.aimTemperature),
                    ViewSpecialAndGeneral(view: currentTemperature, type: .special)])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.toolbar.isHidden = false
    }

}

// MARK: - ModelRoomsConfigDelegate
extension RoomsViewController: ModelRoomsConfigDelegate {
    func setup(result: [Int: String]) {
        self.roomNumbersAndNames = result

        if self.curentVC == self.roomNumbersAndNames.count {
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLast(sender:)))
            let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLast(sender:)))
            upSwipe.direction = .up
            self.view.addGestureRecognizer(rightSwipe)
            self.view.addGestureRecognizer(upSwipe)
        } else if self.curentVC < self.roomNumbersAndNames.count {
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
            let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
            upSwipe.direction = .up
            leftSwipe.direction = .left

            self.view.addGestureRecognizer(leftSwipe)
            self.view.addGestureRecognizer(rightSwipe)
            self.view.addGestureRecognizer(upSwipe)
        }
        self.setTitleAndPageControll()
    }
    func show1(error message: String) {
        print(message)
        self.showAlert()
    }
}

// MARK: - ModelAppDatchikDelegate
extension RoomsViewController: ModelAppDatchikDelegate {
    func show2(error message: String) {
        print(message)
        self.setDefaultValuesForAimParamtrs()
    }
    func setupCurrentAppDatchik() {
        modelRoomDatchik?.fetchAppDatchik(type: .current) { (result: [String: JSON]) in
            //            print(self.curentVC)
            print(self.roomNumbersAndNames.keys.sorted())
            if self.roomNumbersAndNames.count > 0 {
                let currentRoomData = CurrentRoomData(result: result, curentRoom: Array(self.roomNumbersAndNames.keys.sorted())[self.curentVC - 1])
                
                self.currentTemperature.text = currentRoomData.currentTemperature
                self.modOfCurrentTemperature.text = currentRoomData.modOfCurrentTemperature
                self.currentWet.text = currentRoomData.currentWet
                self.modOfTheCurrentWet.text = currentRoomData.modOfCurrentWet
                self.currentGas.text = currentRoomData.currentGas
                //            self.ppmLabel.text = currentRoomData.ppm
                self.peopleInRoom.text = currentRoomData.peopleInRoom
                
                ActivityIndicator.stopAnimating(views: [self.currentTemperature, self.currentWet, self.currentGas, self.peopleInRoom])
            } else {
                self.setupCurrentAppDatchik()
            }
        }
    }

    func setupCurrentAimAppDatchik() {
        modelRoomDatchik?.fetchAppDatchik(type: .aim) { (result: [JSON]) in

            let aimRoomData = AimRoomData(result: result)
            self.aimTemperature.text = aimRoomData.aimTemperature
            self.aimWet.text = aimRoomData.aimWet
            self.aimGas.text = aimRoomData.aimGas

            ActivityIndicator.stopAnimating(views: [self.aimTemperature, self.aimWet, self.aimGas])
        }
    }
}
