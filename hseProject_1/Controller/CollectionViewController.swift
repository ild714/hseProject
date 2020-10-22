//
//  CollectionViewController.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class CollectionViewController: UIViewController,ToolBarWithPageControllProtocol {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var curentRoom: Int = 0
    var roomNumbersAndNames: [Int:String] = [:]
    var safeArea: UILayoutGuide!
//    var roomsNames = []
    
    let cellIdentifier = String(describing: CustomCollectionViewCell.self)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activityIndicator.center.x = self.view.center.x
//        activityIndicator.center.y = self.view.center.y
//        collectionView.addSubview(self.activityIndicator)
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
        title = "Все комнаты"
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.init(red: 41/255.0, green: 114/255.0, blue: 237/255.0, alpha: 1),UIColor.init(red: 41/255.0, green: 252/255.0, blue: 237/255.0, alpha: 1)], startPoint: .topLeft, endPoint: .bottomRight)
        
        NetworkRoomConfig.urlSession(with: "https://vc-srvr.ru/site/rm_config?did=40RRTM304FCdd5M80ods"){(result: Result<[String:JSON],NetworkError>) in
            switch result {
            case .success(let result):
                
                for (_,value) in result {
                    self.roomNumbersAndNames[value["rid"].int ?? 0] = value["r_name"].description
                }
                
                if self.curentRoom == 0 {
                    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeFirst(sender:)))
                    leftSwipe.direction = .left
                    
                    self.view.addGestureRecognizer(leftSwipe)
                }
                self.createPageControl(viewController: self, number: self.curentRoom,allAmountOfPages: self.roomNumbersAndNames.count + 1)
                
                self.collectionView.reloadData()
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    @objc func handleSwipeFirst(sender: UISwipeGestureRecognizer){
        if sender.state == .ended{
            switch sender.direction {
            case .left:
                if let vc = RoomsViewController.storyboardInstance(){
                    navigationController?.pushViewController(vc, animated: true)
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
    
    func setupTableView(){
        view.addSubview(collectionView)
        
        let button = UIButton()
        button.setTitle("Test", for: .normal)
        collectionView.addSubview(button)
        
        collectionView.backgroundColor = UIColor.init(redS: 235, greenS: 235, blueS: 235)
        
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 10
//        collectionView.collectionViewLayout = layout
        
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

//MARK:- UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomNumbersAndNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell

        NetworkSensorData.getData(with: "https://vc-srvr.ru/app/datchik?did=40RRTM304FCdd5M80ods",type: .current){
            (result: Result<[String:JSON],NetworkSensorError>) in
                
            switch result {
            case .success(let result):
                
                let currentRoomData = CurrentRoomData(result: result, curentRoom: indexPath.row + 1)
                
                cell.configure(currentRoomText: self.roomNumbersAndNames[indexPath.row + 1] ?? "", currentRoom: currentRoomData)
                
//                ActivityIndicator.stopAnimating(views: [self.currentTemperature,self.currentWet,self.currentGas,self.peopleInRoom])
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = RoomsViewController.storyboardInstance(){
            vc.curentRoom = indexPath.row + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding
        
//        let cell = CustomCollectionViewCell()
//        let viewCell = cell.loadViewFromNib()
        
//        return CGSize(width: viewCell.frame.width, height: viewCell.frame.height)
        return CGSize(width: collectionViewSize / 2 , height: collectionViewSize / 2)
//        return CGSize(width: UIScreen.main.bounds.width - 20 , height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 20
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

