//
//  SceneDelegate.swift
//  hseProject_1
//
//  Created by Ильдар Нигметзянов on 28.07.2020.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import YandexLoginSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate, YXLObserver {

    var window: UIWindow?
    var navigationController: UINavigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let rootAssembly = RootAssembly()

//            do {
//                print("1")
//                try YXLSdk.shared.activate(withAppId: "0110c0b1e51442cbbe672e4741a65964")
//            } catch {
//                print("2")
//            }
//            YXLSdk.shared.authorize()
//            YXLSdk.shared.add(observer: self)
//
//            let yandexVC = YandexSignInViewController()
//
//            self.window?.rootViewController = yandexVC
//            self.window?.makeKeyAndVisible()

            if UserDefaults.standard.bool(forKey: "Log_in") {
                if let collectionViewController = rootAssembly.presentationAssembly.collectionViewController() {

                    let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                    let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
                    navigationController?.viewControllers = [collectionViewController]

                    navigationController?.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
            } else {
                let signInVC = SignInViewController(rootAssembly: rootAssembly)

                self.window?.rootViewController = signInVC
                self.window?.makeKeyAndVisible()
            }
        }
    }

    func loginDidFinish(with result: YXLLoginResult) {
        print(result)
    }
    func loginDidFinishWithError(_ error: Error) {
        // process error
    }

    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        YXLSdk.shared.processUserActivity(userActivity)
        print("2")
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("3")
        return YXLSdk.shared.handleOpen(url, sourceApplication: sourceApplication)

    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("4")
        return YXLSdk.shared.handleOpen(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
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
