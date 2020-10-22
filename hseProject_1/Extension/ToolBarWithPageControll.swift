//
//  ToolBarWithPageControll.swift
//  hseProject_1
//
//  Created by Ildar on 10/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

protocol ToolBarWithPageControllProtocol{
    func createPageControl<T:UIViewController>(viewController:T,number:Int,allAmountOfPages: Int)
}

extension ToolBarWithPageControllProtocol{

    func createPageControl<T:UIViewController>(viewController:T,number:Int,allAmountOfPages: Int){
        setCurrentPage(viewController: viewController,number:number,allAmountOfPages: allAmountOfPages)
    }
    func setCurrentPage<T:UIViewController>(viewController: T,number:Int,allAmountOfPages: Int) {
        
            let pc = UIPageControl()
            
            pc.numberOfPages = allAmountOfPages
            pc.currentPage = number
            
            pc.isUserInteractionEnabled = false
            pc.currentPageIndicatorTintColor = .blue
            pc.pageIndicatorTintColor = UIColor(redS: 249, greenS: 207, blueS: 224)
            
        viewController.navigationController?.setToolbarHidden(false, animated: false)
//        viewController.navigationController?.toolbar.clipsToBounds = true
        
        viewController.navigationController?.toolbar.barTintColor = UIColor(redS: 235, greenS: 235, blueS: 235, a: 1)
         let pageControlBarButtonItem = UIBarButtonItem(customView: pc)
        viewController.toolbarItems = [pageControlBarButtonItem]

    }
}
