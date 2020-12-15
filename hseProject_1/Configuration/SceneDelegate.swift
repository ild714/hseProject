//
//  SceneDelegate.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            
            if UserDefaults.standard.bool(forKey: "Log_in") {
                if let collectionViewController = CollectionViewController.storyboardInstance(){
                    
                    if let userId = UserDefaults.standard.object(forKey: "UserId") as? String {
                        collectionViewController.userId = userId
                        let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                        
                        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                        
                        navigationController.viewControllers = [collectionViewController]
                        
                        navigationController.modalPresentationStyle = .fullScreen
                        self.window?.rootViewController = navigationController
                        self.window?.makeKeyAndVisible()
                    }
                }
            } else {
                let vc = SignInViewController()
                
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
            
//            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .horizontal
//            let swipingController = SwipingController(collectionViewLayout: layout)
//
//            window?.rootViewController = swipingController
//            window?.makeKeyAndVisible()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

