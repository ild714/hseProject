//
//  ViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/11/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInDelegate {

    let rootAssembly: RootAssembly?

    init(rootAssembly: RootAssembly) {
        self.rootAssembly = rootAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            if let refToken = user.authentication.refreshToken, let aToken = user.authentication.accessToken, let gmail = user.profile.email {
                UserDefaults.standard.set(gmail, forKey: "UserEmail")
                UserDefaults.standard.set(aToken, forKey: "Token")
                UserDefaults.standard.set(refToken, forKey: "refToken")
                print("111")
                let newUser = NewUser()
                newUser.newUser()
            }
            UserDefaults.standard.set(true, forKey: "Log_in")
            if let collectionViewController = rootAssembly?.presentationAssembly.collectionViewController() {
                let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController

                navigationController?.viewControllers = [collectionViewController]
                navigationController?.modalPresentationStyle = .fullScreen

                if let navigationVC = navigationController {
                    self.present(navigationVC, animated: true, completion: nil)
                }
            }
        } else {
            print("\(error.localizedDescription)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.center = view.center

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.clientID = Bundle.main.infoDictionary?["CLIENT_ID"] as? String ?? ""
        GIDSignIn.sharedInstance()?.delegate = self

        view.backgroundColor = .white
        view.addSubview(signInButton)
    }
}
