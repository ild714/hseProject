//
//  ToolBarWithPageControll.swift
//  hseProject_1
//
//  Created by Ildar on 10/9/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

protocol ToolBarWithPageControllProtocol {
    func createPageControl<T: UIViewController>(viewController: T, number: Int, allAmountOfPages: Int)
}

extension ToolBarWithPageControllProtocol {

    func createPageControl<T: UIViewController>(viewController: T, number: Int, allAmountOfPages: Int) {
        setCurrentPage(viewController: viewController, number: number, allAmountOfPages: allAmountOfPages)
    }
    func setCurrentPage<T: UIViewController>(viewController: T, number: Int, allAmountOfPages: Int) {

            let pageControl = UIPageControl()
            pageControl.numberOfPages = allAmountOfPages
            pageControl.currentPage = number
            pageControl.isUserInteractionEnabled = false
            pageControl.currentPageIndicatorTintColor = .blue
            pageControl.pageIndicatorTintColor = UIColor(redS: 249, greenS: 207, blueS: 224)

        viewController.navigationController?.setToolbarHidden(false, animated: false)
        viewController.navigationController?.toolbar.barTintColor = UIColor(redS: 235, greenS: 235, blueS: 235, alpha: 1)
        let pageControlBarButtonItem = UIBarButtonItem(customView: pageControl)
        viewController.toolbarItems = [pageControlBarButtonItem]
    }
}
