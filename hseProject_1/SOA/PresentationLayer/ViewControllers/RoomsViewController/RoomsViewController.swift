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

    init?(coder: NSCoder,
          presentationAssembly: PresentationAssemblyProtocol,
          userId: String,
          curentVC: Int,
          roomNumbersAndNames: [Int: String],
          resultDatchik: [String: JSON],
          currentRoomData: CurrentRoomData?, aimData: [(key: Int, value: AimRoomScript)]) {
        self.presentationAssembly = presentationAssembly
        self.userId = userId
        self.curentVC = curentVC
        self.roomNumbersAndNames = roomNumbersAndNames
        self.resultDatchik = resultDatchik
        self.currentRoomData = currentRoomData
        self.aimRoomsData = aimData
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var aimRoomsData: [(key: Int, value: AimRoomScript)] = []
    private var presentationAssembly: PresentationAssemblyProtocol?
    private var menu: SideMenuNavigationController?
    private var userId = ""
    private var curentVC: Int = 1
    private var roomNumbersAndNames: [Int: String] = [:]
    private var resultDatchik: [String: JSON] = [:]
    private var currentRoomData: CurrentRoomData?
    private var switchRoom = false

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewCO2: UIStackView!
    @IBOutlet weak var stackViewWet: UIStackView!
    @IBOutlet weak var stackViewTemperature: UIStackView!

    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var aimTemperature: LabelRightSideCustomClass!

    @IBOutlet weak var currentWet: UILabel!
    @IBOutlet weak var aimWet: LabelRightSideCustomClass!

    @IBOutlet weak var currentGas: UILabel!
    @IBOutlet weak var aimGas: LabelRightSideCustomClass!

    @IBOutlet weak var peopleInRoom: LabelRightSideCustomClass!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.toolbar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMenuForNavigationController()
        self.createButtonForNavigationController()
        self.addWhiteColorForStackViews()
        self.setGradientForNavigation()
        self.deleteBackButtonFromNavigation()
        self.startAnimation()
        self.setupGesturesForRoomNumbersAndNames()
        self.setupCurrentResultAppDatchik()
//        self.setDefaultValuesForAimParamtrs()
        self.setupAimData()
    }
    func createMenuForNavigationController() {
        if let presentationAssembly = self.presentationAssembly {
            menu = SideMenuNavigationController(rootViewController: MenuListController(userId: self.userId, presentationAssembly: presentationAssembly))
            menu?.leftSide = true
            menu?.enableSwipeToDismissGesture = false
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
        self.navigationController?.navigationBar.setGradientBackground(
            colors: [UIColor.init(red: 41/255.0, green: 114/255.0, blue: 237/255.0, alpha: 1),
                     UIColor.init(red: 41/255.0, green: 252/255.0, blue: 237/255.0, alpha: 1)],
            startPoint: .topLeft,
            endPoint: .bottomRight)
    }
    func deleteBackButtonFromNavigation() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    func startAnimation() {
        ActivityIndicator.animateActivity(
            views: [ViewSpecialAndGeneral(view: self.aimWet),
                    ViewSpecialAndGeneral(view: self.currentGas),
                    ViewSpecialAndGeneral(view: self.currentWet),
                    ViewSpecialAndGeneral(view: self.peopleInRoom),
                    ViewSpecialAndGeneral(view: self.aimGas),
                    ViewSpecialAndGeneral(view: self.aimTemperature),
                    ViewSpecialAndGeneral(view: currentTemperature, type: .special)])
    }
    func setupGesturesForRoomNumbersAndNames() {
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
    func setTitleAndPageControll() {
        self.title = Array(self.roomNumbersAndNames.values.sorted())[self.curentVC - 1]
        self.createPageControll()
    }
    func createPageControll() {
        self.createPageControl(viewController: self, number: self.curentVC, allAmountOfPages: self.roomNumbersAndNames.count + 1)
    }
    func setupCurrentResultAppDatchik() {
        if self.roomNumbersAndNames.count > 0 {
            self.currentTemperature.text = currentRoomData?.currentTemperature
            self.currentWet.text = currentRoomData?.currentWet
            self.currentGas.text = currentRoomData?.currentGas
            self.peopleInRoom.text = currentRoomData?.peopleInRoom

            ActivityIndicator.stopAnimating(views: [self.currentTemperature, self.currentWet, self.currentGas, self.peopleInRoom])
        }
    }
    func setupAimData() {
        let aimData = self.aimRoomsData[self.curentVC - 1]
        self.aimTemperature.text = String(aimData.value.temp) + "℃"
        self.aimGas.text = String(aimData.value.co2)
        self.aimWet.text = String(aimData.value.humidity)
        ActivityIndicator.stopAnimating(views: [self.aimTemperature, self.aimWet, self.aimGas])
    }

    @IBAction func minusTemperature(_ sender: Any) {
        self.aimTemperature.text = TemperatureConfig.minus(string: aimTemperature.text ?? "20") ?? "30℃"
    }

    @IBAction func plusTemperature(_ sender: Any) {
        self.aimTemperature.text = TemperatureConfig.plus(string: aimTemperature.text ?? "20") ?? "15℃"
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                navigationController?.popViewController(animated: true)
            case .left:
                if let roomsVC = presentationAssembly?.roomsViewController(curentVC: self.curentVC + 1,
                                                                           roomNumbersAndNames: self.roomNumbersAndNames,
                                                                           resultDatchik: self.resultDatchik,
                                                                           currentRoomData:
                                                                            CurrentRoomData(result: resultDatchik, curentRoom: Array(self.roomNumbersAndNames.keys.sorted())[self.curentVC]), aimRoom: aimRoomsData) {
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
    @IBOutlet weak var minusButton: ButtonLeftSideCustomClass!
    @IBOutlet weak var plusButton: ButtonRightSideCustomClass!
    func setDefaultValuesForAimParamtrs() {
        self.aimTemperature.text = "-"
        self.aimWet.text = "-"
        self.aimGas.text = "-"
        ActivityIndicator.stopAnimating(views: [self.aimTemperature, self.aimWet, self.aimGas])
        minusButton.isEnabled = false
        plusButton.isEnabled = false
    }
    func showAlert() {
        let alertVC = UIAlertController(title: "Ошибка подключения к wi-fi", message: "Включите wi-fi и перезапустите приложение", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}
