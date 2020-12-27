//
//  YandexSignInViewController.swift
//  IndoorClimateControlSystems
//
//  Created by Ildar on 12/21/20.
//  Copyright © 2020 Ildar Nigmetzyanov. All rights reserved.
//

import UIKit
import YandexLoginSDK

class YandexSignInViewController: UIViewController, YXLObserver {

    override func viewDidLoad() {
        super.viewDidLoad()

        YXLSdk.shared.authorize()
        YXLSdk.shared.add(observer: self)
        view.backgroundColor = .white
//        let vc = YandexLoginSDK
//        YXLSdk.shared.authorize()
//        self.present(vc, animated: true)
    }

    func loginDidFinish(with result: YXLLoginResult) {
        print("!!!!!!!!!!!!")
        print(result.token)
    }
    func loginDidFinishWithError(_ error: Error) {
        // process error
        print("!!!!!!!!????????")
        print(error.localizedDescription)
    }
}
