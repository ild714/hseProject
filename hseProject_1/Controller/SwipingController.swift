//
//  SwipingController.swift
//  hseProject_1
//
//  Created by Ildar on 10/8/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupBottomControls()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.isPagingEnabled = true
    }
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        
        pc.currentPage = 0
        pc.numberOfPages = 4
        
        pc.currentPageIndicatorTintColor = .blue
        pc.pageIndicatorTintColor = UIColor(redS: 249, greenS: 207, blueS: 224)
        
        return pc
    }()
    
    fileprivate func setupBottomControls(){
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)])
    }
}

extension SwipingController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height: view.frame.height)
    }
    
}

extension SwipingController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
