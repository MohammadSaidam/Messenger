//
//  LoginViewController.swift
//  Messenger
//
//  Created by Mohammed Saidam on 22/01/2023.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log In"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done, target: self,
                                                            action: #selector(DidTapRegister))
    }
    // This function that push RegisterViewController
    @objc private func DidTapRegister(){
        var vc = RegisterViewController()
        // this code is put tittel in navigation bar for RegisterViewController
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

 

}
