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
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            print("___________")
            print(user.userID ?? "no id")
            print("___________")
            print(user.authentication.idToken ?? "no token")
            print("___________")
            if let collectionViewController = CollectionViewController.storyboardInstance(){
                
                collectionViewController.userId = user.userID
                let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                
                let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                
                navigationController.viewControllers = [collectionViewController]
                
                navigationController.modalPresentationStyle = .fullScreen
                
                UserDefaults.standard.set(true, forKey: "Log_in")
                //print(user.userID)
//                print(type(of: Int(user.userID)))
                if let userId = user.userID, let token = user.authentication.idToken {


                    UserDefaults.standard.set(userId, forKey: "UserId")
                    UserDefaults.standard.set(token, forKey: "Token")
                }
                
                self.present(navigationController, animated: true, completion: nil)
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
        
        GIDSignIn.sharedInstance()?.clientID = "930671898521-i7e7l2r541stcjqmnrdpg8e9q9t9no8j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(signInButton)
    }
}
