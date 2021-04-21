//
//  ViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/11/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import KeychainAccess

class SignInViewController: UIViewController, GIDSignInDelegate {
   
    var rootAssembly: RootAssembly?
    
    //    init(rootAssembly: RootAssembly) {
//        self.rootAssembly = rootAssembly
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

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
            signInComplete()
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func signInComplete() {
        UserDefaults.standard.set(true, forKey: "Log_in")
        if let collectionViewController = rootAssembly?.presentationAssembly.collectionViewController() {
            let storyboard: UIStoryboard = UIStoryboard(name: "CollectionViewController", bundle: nil)
            let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController

            navigationController?.viewControllers = [collectionViewController]
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.modalPresentationStyle = .fullScreen

            if let navigationVC = navigationController {
                self.present(navigationVC, animated: true, completion: nil)
            }
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
        
        let sighInBtn = ASAuthorizationAppleIDButton()
        sighInBtn.frame = CGRect(x: 20, y: (UIScreen.main.bounds.size.height - 170), width: 115, height: 40)
        sighInBtn.center = CGPoint(x: view.center.x, y: view.center.y + 50)
        sighInBtn.addTarget(self, action: #selector(signInActionBtn), for: .touchUpInside)
        self.view.addSubview(sighInBtn)
    }
    
    @objc func signInActionBtn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    static func storyboardInstance() -> SignInViewController? {
        let storyboard = UIStoryboard(name: "SignInViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? SignInViewController
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
//            print(credential.user)
//            print(credential.email)
//            let keychain = Keychain(service: "com.nigmetzyanov.IndoorClimateControlSystems")
            print(credential.identityToken?.description)
            UserDefaults.standard.set("apple", forKey: "UserEmail")

            self.signInComplete()
        case let credentials as ASPasswordCredential:
            print(credentials.password)
        default:
            let alert = UIAlertController(title: "Apple SignIn", message: "Someting wrong with your Apple SignIn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print(error.localizedDescription)
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
