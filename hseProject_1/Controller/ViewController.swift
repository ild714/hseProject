//
//  ViewController.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
        
//    var countRoom = 0
    var roomNumber = 1
    var switchRoom = false
    
    @IBOutlet weak var roomName: UILabel!
    
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var aimTemperature: LabelRightSideCustomClass!
    
    @IBOutlet weak var currentWet: UILabel!
    @IBOutlet weak var aimWet: LabelRightSideCustomClass!
    
    @IBOutlet weak var currentGas: UILabel!
    @IBOutlet weak var aimGas: LabelRightSideCustomClass!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicator.animateActivity(view: self.currentTemperature)
        ActivityIndicator.animateActivity(view: self.currentWet)
        ActivityIndicator.animateActivity(view: self.currentGas)
        ActivityIndicator.animateActivity(view: self.peopleInRoom)
//        ActivityIndicator.animateActivity(view: self.roomName)
        ActivityIndicator.animateActivity(view: self.aimGas)
        ActivityIndicator.animateActivity(view: self.aimTemperature)
        ActivityIndicator.animateActivity(view: self.aimWet)
        
        NetworkRoomConfig.urlSession(with: "https://vc-srvr.ru/site/rm_config?did=40RRTM304FCdd5M80ods"){(result: Result<Rooms,NetworkError>) in
            switch result {
            case .success(let result):
                ActivityIndicator.stopAnimating(view: self.roomName)
                if self.roomNumber == 1 {
                    self.roomName.text = result.r_0.r_name
                } else if self.roomNumber == 2 {
                    self.roomName.text = result.r_1.r_name
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/datchik?did=40RRTM304FCdd5M80ods",type: .current){
            (result: Result<[String:JSON],NetworkSensorError>) in
                
            switch result {
            case .success(let result):
//                self.countRoom = result.count
//                print(self.countRoom)
                for data in result["\(self.roomNumber)"]! {
                        
                        if data.0 == "1"{
                            ActivityIndicator.stopAnimating(view: self.currentTemperature)
                            self.currentTemperature.text = "\(data.1)℃"
                        } else if data.0 == "3"{
                            ActivityIndicator.stopAnimating(view: self.currentWet)
                            self.currentWet.text = "\(data.1)%"
                        } else if data.0 == "4"{
                            ActivityIndicator.stopAnimating(view: self.currentGas)
                            self.currentGas.text = "\(data.1)ppm"
                        } else if data.0 == "5" {
                            ActivityIndicator.stopAnimating(view: self.peopleInRoom)
                            self.peopleInRoom.text = "\(data.1)"
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/scen/get_cur?did=40RRTM304FCdd5M80ods&rid=\(self.roomNumber)",type: .aim){
            (result: Result<[JSON],NetworkSensorError>) in
                
            switch result {
            case .success(let result):
                var step = 1
                for data in result {
                    if step == 1 {
                        ActivityIndicator.stopAnimating(view: self.aimTemperature)
                        self.aimTemperature.text = "\(data)℃"
                        step += 1
                    } else if step == 2 {
                        ActivityIndicator.stopAnimating(view: self.aimWet)
                         self.aimWet.text = "\(data)%"
                        step += 1
                    } else if step == 3 {
                        ActivityIndicator.stopAnimating(view: self.aimGas)
                        self.aimGas.text = "\(data)ppm"
                        step += 1
                    }
                }
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    @IBAction func nextRoom(_ sender: Any) {
        self.roomNumber = switchRoom == true ? 1 : 2
        self.switchRoom = switchRoom == false ? true : false
        self.aimTemperature.text = ""
        self.currentTemperature.text = ""
        self.aimWet.text = ""
        self.currentWet.text = ""
        self.aimGas.text = ""
        self.currentGas.text = ""
        self.peopleInRoom.text = ""
        self.viewDidLoad()
    }
    
    @IBAction func previousRoom(_ sender: Any) {
        self.roomNumber = switchRoom == true ? 1 : 2
        self.switchRoom = switchRoom == false ? true : false
        self.aimTemperature.text = ""
        self.currentTemperature.text = ""
        self.aimWet.text = ""
        self.currentWet.text = ""
        self.aimGas.text = ""
        self.currentGas.text = ""
        self.peopleInRoom.text = ""
        self.viewDidLoad()
    }
    
}

