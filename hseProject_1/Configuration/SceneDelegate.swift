//
//  SceneDelegate.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let rootAssembly = RootAssembly()

            GIDSignIn.sharedInstance()?.clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as? String ?? ""
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()

            if UserDefaults.standard.bool(forKey: "Log_in") {
                if let collectionViewController = rootAssembly.presentationAssembly.collectionViewController() {
                    let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                    let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
                    navigationController?.viewControllers = [collectionViewController]
                    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
                    navigationController?.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }

//                let signInVC = SignInViewController(rootAssembly: rootAssembly)
//                self.window?.rootViewController = signInVC
//                self.window?.makeKeyAndVisible()
            } else {

                let signInVC = SignInViewController(rootAssembly: rootAssembly)
                self.window?.rootViewController = signInVC
                self.window?.makeKeyAndVisible()
                print("222")
//                let newUser = NewUser()
//                newUser.newUser()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let rootAssembly = RootAssembly()

            GIDSignIn.sharedInstance()?.clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as? String ?? ""
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()

            if UserDefaults.standard.bool(forKey: "Log_in") {
                if let collectionViewController = rootAssembly.presentationAssembly.collectionViewController() {
                    let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                    let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
                    navigationController?.viewControllers = [collectionViewController]
                    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

                    navigationController?.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
//                let signInVC = SignInViewController(rootAssembly: rootAssembly)
//                GIDSignIn.sharedInstance()?.clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as? String ?? ""
//                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//                self.window?.rootViewController = signInVC
//                self.window?.makeKeyAndVisible()
            } else {
                let signInVC = SignInViewController(rootAssembly: rootAssembly)
                self.window?.rootViewController = signInVC
                self.window?.makeKeyAndVisible()
//                let newUser = NewUser()
//                newUser.newUser()
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}
