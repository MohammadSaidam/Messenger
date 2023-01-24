//
//  LoginViewController.swift
//  Messenger
//
//  Created by Mohammed Saidam on 22/01/2023.
//

import UIKit

class LoginViewController: UIViewController {
    private var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private var imageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        
        return imageView
        
    }()
    private var emailFeild:UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1 //means 1px
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
        
    }()
    
    private var passwordField:UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1 //means 1px
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        
        return field
        
    }()
    private var logInButton:UIButton = {
        var button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .link // background button
        button.setTitleColor(.white, for: .normal)// color of login word
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold) // type of font style bold or italic ect.
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log In"
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done, target: self,
                                                            action: #selector(DidTapRegister))
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailFeild)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(logInButton)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/4
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y:20,
                                 width: scrollView.width/4,
                                 height: scrollView.width/4)
        
        emailFeild.frame = CGRect(x: 30,
                                  y:imageView.bottom+18,
                                  width: scrollView.width-60,
                                  height:50)
        
        passwordField.frame = CGRect(x: 30,
                                     y:emailFeild.bottom+10 ,
                                     width: scrollView.width-60,
                                     height: 50)
        
        logInButton.frame = CGRect(x: 30,
                                   y:passwordField.bottom+20 ,
                                   width: scrollView.width-60,
                                   height: 50)
    }
    // This function that push RegisterViewController
    @objc private func DidTapRegister(){
        let vc = RegisterViewController()
        // this code is put title in navigation bar for RegisterViewController
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
}
