//
//  ViewController.swift
//  Messenger
//
//  Created by Mohammed Saidam on 22/01/2023.
//

import UIKit
import FirebaseAuth


class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "LoggedIn")
        // this condition say if the user is not loggedIn appliaction
        // I want to present LoginViewController
//        if !isLoggedIn {
//            let vc = LoginViewController()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//
//           present(nav,animated: false)
//        }
    }
    private func validateAuth(){
        if  FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            
            present(nav,animated: false)
        }
        
    }


}

