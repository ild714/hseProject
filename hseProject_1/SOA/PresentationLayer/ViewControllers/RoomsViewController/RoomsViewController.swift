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
          currentRoomData: CurrentRoomData?,
          modelAimData: ModelAimDataProtocol) {
        self.presentationAssembly = presentationAssembly
        self.userId = userId
        self.curentVC = curentVC
        self.roomNumbersAndNames = roomNumbersAndNames
        self.resultDatchik = resultDatchik
        self.currentRoomData = currentRoomData
//        self.aimRoomsData = aimData
        self.modelAimData = modelAimData
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

    private var modelAimData: ModelAimDataProtocol?
//    private var aimRoomScripts: [Int: AimRoomScript] = [:]

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

    @IBOutlet weak var ventilateButton: ButtonCustomClass!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.toolbar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.minusButton.showsTouchWhenHighlighted = true
        self.createMenuForNavigationController()
        self.createButtonForNavigationController()
        self.addWhiteColorForStackViews()
        self.setGradientForNavigation()
        self.deleteBackButtonFromNavigation()
        self.startAnimation()
        self.setupGesturesForRoomNumbersAndNames()
//        self.setDefaultValuesForAimParamtrs()
        if UserDefaults.standard.object(forKey: "UserEmail") as? String == "apple" ||  UserDefaults.standard.object(forKey: "UserEmail") as? String == "test" {
            self.setupCurrentResultAppDatchikTest()
            setDefaultValuesForAimParamtrs()
        } else {
            self.setupCurrentResultAppDatchik()
            self.modelAimData?.fetchAimData()
        }
    }
    func createMenuForNavigationController() {
        if let presentationAssembly = self.presentationAssembly {
            menu = SideMenuNavigationController(rootViewController: MenuListController(userId: self.userId, presentationAssembly: presentationAssembly, collectionSelf: nil, roomsController: self))
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
        let keyId = Array(self.roomNumbersAndNames.keys.sorted())[self.curentVC - 1]
        self.title = self.roomNumbersAndNames[keyId] ?? "No value"
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
    func setupCurrentResultAppDatchikTest() {
        if self.roomNumbersAndNames.count > 0 {
            self.currentTemperature.text = "20℃"
            self.currentWet.text = "44.0%"
            self.currentGas.text = "686ppm"
            self.peopleInRoom.text = "0"
            
            ActivityIndicator.stopAnimating(views: [self.currentTemperature, self.currentWet, self.currentGas, self.peopleInRoom])
        }
    }
    var ventilate = 0
    var chNotNil = false
    func setupAimData() {
        if self.aimRoomsData.count != self.roomNumbersAndNames.count || self.aimRoomsData.count == 0 {
            self.setDefaultValuesForAimParamtrs()
        } else {
            let aimData = self.aimRoomsData[self.curentVC - 1]
            if aimData.value.ch_temp != nil {
                if let tempChanged = aimData.value.ch_temp {
//                    chNotNil = true
                    self.aimTemperature.text = "\(tempChanged)/\(String(aimData.value.temp))℃"
                }
            } else {
                self.aimTemperature.text = String(aimData.value.temp) + "℃"
            }
            if aimData.value.flow == 1 {
                ventilate = 1
                self.ventilateButton.backgroundColor = .white
                self.ventilateButton.setTitleColor(UIColor(redS: 155, greenS: 155, blueS: 155), for: .normal)
            } else {
                self.ventilateButton.startColor = UIColor(redS: 91, greenS: 128, blueS: 234, alpha: 1)
                self.ventilateButton.endColor = UIColor(redS: 55, greenS: 181, blueS: 221, alpha: 1)
                self.ventilateButton.setTitleColor(.white, for: .normal)
            }
            self.aimGas.text = String(aimData.value.co2) + "ppm"
            self.aimWet.text = String(aimData.value.humidity) + "%"
            ActivityIndicator.stopAnimating(views: [self.aimTemperature, self.aimWet, self.aimGas])
        }
    }

    @IBAction func minusTemperature(_ sender: Any) {
        let changeTemp = ChangeTemp()
        let aimTempCopy = TemperatureConfig.minus(string: aimTemperature.text ?? "20") ?? "30℃"
        if let tempInt = Int(aimTempCopy.prefix(2) ) {
            changeTemp.changeTemp(rid: aimRoomsData[self.curentVC - 1].key, temp: tempInt) {
                self.modelAimData?.fetchAimData()
            }
        }
    }

    @IBAction func plusTemperature(_ sender: Any) {
        let changeTemp = ChangeTemp()
        let aimTempCopy = TemperatureConfig.plus(string: aimTemperature.text ?? "20") ?? "15℃"
        if let tempInt = Int(aimTempCopy.prefix(2)) {
            changeTemp.changeTemp(rid: aimRoomsData[self.curentVC - 1].key, temp: tempInt) {
                self.modelAimData?.fetchAimData()
            }
        }
    }
    @IBAction func ventilate(_ sender: Any) {
        if ventilate == 1 {
            showAlert(title: "Помещение уже проветривается", message: "")
        } else {
            let ventilateRoom = VentilateRoom()
            if isSetDefault {
            } else {
                ventilateRoom.ventilate(rid: aimRoomsData[self.curentVC - 1].key) {
                    self.modelAimData?.fetchAimData()
                }
                self.ventilateButton.isEnabled = false
            }
        }
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
                                                                            CurrentRoomData(result: resultDatchik, curentRoom: Array(self.roomNumbersAndNames.keys.sorted())[self.curentVC])) {
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

    var isSetDefault = false
    func setDefaultValuesForAimParamtrs() {
        isSetDefault = true
        self.aimTemperature.text = "-"
        self.aimWet.text = "-"
        self.aimGas.text = "-"
        ActivityIndicator.stopAnimating(views: [self.aimTemperature, self.aimWet, self.aimGas])
        minusButton.isEnabled = false
        plusButton.isEnabled = false
        self.ventilateButton.isEnabled = false
    }
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}

// MARK: - ModelAimDataDelegate
extension RoomsViewController: ModelAimDataDelegate {
    func setup(result: [Int: AimRoomScript]) {
        aimRoomsData = result.sorted(by: { $0.0 < $1.0 })
        self.setupAimData()
    }

    func show3(error message: String) {
        print(message.description)
        self.setDefaultValuesForAimParamtrs()
    }
}

// MARK: - CollectionUpdate
extension RoomsViewController: RoomsViewUpdate {
    func update() {
        self.modelAimData?.fetchAimData()
//        self.menu?.dismiss(animated: true, completion: nil)
    }
}
