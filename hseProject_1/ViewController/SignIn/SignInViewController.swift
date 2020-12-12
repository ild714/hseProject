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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            print(user.profile.email)
            if let collectionViewController = CollectionViewController.storyboardInstance(){
                
                let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
                
                let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                
                navigationController.viewControllers = [collectionViewController]
                
                navigationController.modalPresentationStyle = .fullScreen
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
//        signInButton.layer.cornerRadius = 5
//        signInButton.layer.borderWidth = 1
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.clientID = "930671898521-i7e7l2r541stcjqmnrdpg8e9q9t9no8j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        
        
        view.backgroundColor = .white
        view.addSubview(signInButton)
    }
}
