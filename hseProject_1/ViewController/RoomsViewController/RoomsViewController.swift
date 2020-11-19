//
//  ViewController.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class RoomsViewController: UIViewController,ToolBarWithPageControllProtocol {
        
    var curentRoom: Int = 1
    var roomNumbersAndNames: [Int:String] = [:]
    var switchRoom = false
    
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
        NetworkTemperatureResponse.getResponse(with: "https://vc-srvr.ru/app/scen/get_cur?did=40RRTM304FCdd5M80ods&rid=1"){  (result: Result<String,NetworkTemperatureError>) in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended{
            switch sender.direction {
            case .right:
                navigationController?.popViewController(animated: true)
            case .left:
                if let vc = RoomsViewController.storyboardInstance(){
                    vc.curentRoom += 1
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .up:
                if let vc = ScriptsViewController.storyboardInstance(){
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [vc]
                    present(navigationController, animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }
    
    @objc func handleSwipeLast(sender: UISwipeGestureRecognizer){
           if sender.state == .ended{
               switch sender.direction {
               case .right:
                   navigationController?.popViewController(animated: true)
               case .up:
                    print("up")
                if let vc = ScriptsViewController.storyboardInstance(){
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [vc]
                    present(navigationController, animated: true, completion: nil)
                }
               default:
                   break
               }
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Addition for white background color
        stackView.backColor(stackView: stackView)
        stackViewCO2.backColor(stackView: stackViewCO2)
        stackViewWet.backColor(stackView: stackViewWet)
        stackViewTemperature.backColor(stackView: stackViewTemperature)
        
        // Code for gradient color of navigationController
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.init(red: 41/255.0, green: 114/255.0, blue: 237/255.0, alpha: 1),UIColor.init(red: 41/255.0, green: 252/255.0, blue: 237/255.0, alpha: 1)], startPoint: .topLeft, endPoint: .bottomRight)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        NetworkRoomConfig.urlSession(with: "https://vc-srvr.ru/site/rm_config?did=40RRTM304FCdd5M80ods"){(result: Result<[String:JSON],NetworkError>) in
            switch result {
            case .success(let result):
                
                for (_,value) in result {
                    self.roomNumbersAndNames[value["rid"].int ?? 0] = value["r_name"].description
                }
                
                if self.curentRoom == self.roomNumbersAndNames.count {
                    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLast(sender:)))
                    let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLast(sender:)))
                    upSwipe.direction = .up
                    self.view.addGestureRecognizer(rightSwipe)
                    self.view.addGestureRecognizer(upSwipe)
                } else if self.curentRoom < self.roomNumbersAndNames.count{
                    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
                    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
                    let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(sender:)))
                    upSwipe.direction = .up
                    leftSwipe.direction = .left
                    
                    self.view.addGestureRecognizer(leftSwipe)
                    self.view.addGestureRecognizer(rightSwipe)
                    self.view.addGestureRecognizer(upSwipe)
                }
                self.createPageControl(viewController: self, number: self.curentRoom,allAmountOfPages: self.roomNumbersAndNames.count + 1)
                
                self.title = self.roomNumbersAndNames[self.curentRoom]
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        ActivityIndicator.animateActivity(views: [ViewSpecialAndGeneral(view:self.aimWet, type: .special),ViewSpecialAndGeneral(view: self.currentGas),ViewSpecialAndGeneral(view: self.currentWet,type: .special),ViewSpecialAndGeneral(view: self.peopleInRoom),ViewSpecialAndGeneral(view: self.aimGas),ViewSpecialAndGeneral(view: self.aimTemperature),ViewSpecialAndGeneral(view: currentTemperature,type: .special)])
        
        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/datchik?did=40RRTM304FCdd5M80ods",type: .current){
            (result: Result<[String:JSON],NetworkSensorError>) in
                
            switch result {
            case .success(let result):
                
                let currentRoomData = CurrentRoomData(result: result, curentRoom: self.curentRoom)
                
                self.currentTemperature.text = currentRoomData.currentTemperature
                self.modOfCurrentTemperature.text = currentRoomData.modOfCurrentTemperature
                self.currentWet.text = currentRoomData.currentWet
                self.modOfTheCurrentWet.text = currentRoomData.modOfCurrentWet
                self.currentGas.text = currentRoomData.currentGas
                self.ppmLabel.text = currentRoomData.ppm
                self.peopleInRoom.text = currentRoomData.peopleInRoom
                
                ActivityIndicator.stopAnimating(views: [self.currentTemperature,self.currentWet,self.currentGas,self.peopleInRoom])
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/scen/get_cur?did=40RRTM304FCdd5M80ods&rid=\(self.curentRoom)",type: .aim){
            (result: Result<[JSON],NetworkSensorError>) in

            switch result {
            case .success(let result):
                
                let aimRoomData = AimRoomData(result: result)
                
                self.aimTemperature.text = aimRoomData.aimTemperature
                self.aimWet.text = aimRoomData.aimWet
                self.aimGas.text = aimRoomData.aimGas
                
                ActivityIndicator.stopAnimating(views: [self.aimTemperature,self.aimWet,self.aimGas])
                
            case .failure(let error):
                print(error.localizedDescription)
                self.aimTemperature.text = "-"
                self.aimWet.text = "-"
                self.aimGas.text = "-"
                ActivityIndicator.stopAnimating(views: [self.aimTemperature,self.aimWet,self.aimGas])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.toolbar.isHidden = false
    }
    
    static func storyboardInstance() -> RoomsViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? RoomsViewController
    }
    
}
