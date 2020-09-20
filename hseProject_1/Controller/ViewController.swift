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
        
    var curentRoom: Int = 1
    var roomNumbersAndNames: [Int:String] = [:]
    var switchRoom = false
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewCO2: UIStackView!
    @IBOutlet weak var stackViewWet: UIStackView!
    @IBOutlet weak var stackViewTemperature: UIStackView!
    
    @IBOutlet weak var previousVC: UIButton!
    @IBOutlet weak var nextVC: UIButton!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.backColor(stackView: stackView)
        stackViewCO2.backColor(stackView: stackViewCO2)
        stackViewWet.backColor(stackView: stackViewWet)
        stackViewTemperature.backColor(stackView: stackViewTemperature)
        
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.init(red: 41/255.0, green: 114/255.0, blue: 237/255.0, alpha: 1),UIColor.init(red: 41/255.0, green: 252/255.0, blue: 237/255.0, alpha: 1)], startPoint: .topLeft, endPoint: .bottomRight)
        
        if self.curentRoom == 1 {
            self.previousVC.isHidden = true
        } 
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        ActivityIndicator.animateActivity(view: self.currentTemperature,typeOfActivity: .special)
        ActivityIndicator.animateActivity(view: self.currentGas)
        ActivityIndicator.animateActivity(view: self.currentWet)
        ActivityIndicator.animateActivity(view: self.peopleInRoom)
        ActivityIndicator.animateActivity(view: self.aimGas)
        ActivityIndicator.animateActivity(view: self.aimTemperature)
        ActivityIndicator.animateActivity(view: self.aimWet)
        
        NetworkRoomConfig.urlSession(with: "https://vc-srvr.ru/site/rm_config?did=40RRTM304FCdd5M80ods"){(result: Result<[String:JSON],NetworkError>) in
            switch result {
            case .success(let result):
                
                for (_,value) in result {
                    self.roomNumbersAndNames[value["rid"].int ?? 0] = value["r_name"].description
                }

                if self.curentRoom == self.roomNumbersAndNames.count {
                    self.nextVC.isHidden = true
                }
                
                self.title = self.roomNumbersAndNames[self.curentRoom]
                

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/datchik?did=40RRTM304FCdd5M80ods",type: .current){
            (result: Result<[String:JSON],NetworkSensorError>) in
                
            switch result {
            case .success(let result):

                for data in result["\(self.curentRoom)"]! {
                        
                        if data.0 == "1"{
                            ActivityIndicator.stopAnimating(view: self.currentTemperature)
                            self.currentTemperature.text = "\(Int(floor(data.1.doubleValue)))."
                            self.modOfCurrentTemperature.text = "\(String(String(data.1.doubleValue)[3...4]))℃"
                        } else if data.0 == "3"{
                            ActivityIndicator.stopAnimating(view: self.currentWet)
                            self.currentWet.text = "\(Int(floor(data.1.doubleValue)))."
                            print(data.1)
                            self.modOfTheCurrentWet.text = "\(String(String(data.1.doubleValue)[3...4]))%"
                        } else if data.0 == "4"{
                            ActivityIndicator.stopAnimating(view: self.currentGas)
                            self.currentGas.text = "\(data.1)"
                            self.ppmLabel.text = "ppm"
                            
                        } else if data.0 == "5" {
                            ActivityIndicator.stopAnimating(view: self.peopleInRoom)
                            self.peopleInRoom.text = "\(data.1)"
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/scen/get_cur?did=40RRTM304FCdd5M80ods&rid=\(self.curentRoom)",type: .aim){
            (result: Result<[JSON],NetworkSensorError>) in
                
            switch result {
            case .success(let result):
                var step = 1
                for data in result {
                    if step == 1 {
                        ActivityIndicator.stopAnimating(view: self.aimTemperature)
                        if data.rawString() == "null"{
                           self.aimTemperature.text = "24℃"
                        } else {
                            self.aimTemperature.text = "\(data)℃"
                        }
                        step += 1
                    } else if step == 2 {
                        ActivityIndicator.stopAnimating(view: self.aimWet)
                         if data.rawString() == "null"{
                            self.aimWet.text = "45%"
                         } else {
                            self.aimWet.text = "\(data)%"
                        }
                        step += 1
                    } else if step == 3 {
                        ActivityIndicator.stopAnimating(view: self.aimGas)
                        if data.rawString() == "null"{
                           self.aimGas.text = "700ppm"
                        } else {
                            self.aimGas.text = "\(data)ppm"
                        }
                        step += 1
                    }
                }
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    @IBAction func previous(_ seg: UIStoryboardSegue) {
        if seg.identifier == "previous" {
            guard let vc = seg.destination as? ViewController else {return}
                self.curentRoom -= 1
                vc.curentRoom = self.curentRoom
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            guard let vc = segue.destination as? ViewController else {return}

                self.curentRoom += 1
                vc.curentRoom = self.curentRoom
        }
    }
    
    
}
