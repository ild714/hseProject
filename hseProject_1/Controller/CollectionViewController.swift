//
//  CollectionViewController.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate {

    var safeArea: UILayoutGuide!
    var roomsNames = ["Кухня","Гостиная","Спальня"]
    
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
        
        title = "Все комнаты"
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.init(red: 41/255.0, green: 114/255.0, blue: 237/255.0, alpha: 1),UIColor.init(red: 41/255.0, green: 252/255.0, blue: 237/255.0, alpha: 1)], startPoint: .topLeft, endPoint: .bottomRight)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        collectionView.addGestureRecognizer(leftSwipe)
        leftSwipe.direction = .left
        
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended{
            switch sender.direction {
            case .left:
                if let vc = ViewController.storyboardInstance(){
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
        
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.init(red: 247, green: 245, blue: 240)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
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

extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell

        
        
        cell.configure(nameRoom: roomsNames[indexPath.row])
        
        return cell
    }
    
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2 , height: collectionViewSize / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 20
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
