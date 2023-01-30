//
//  LoginViewController.swift
//  Messenger
//
//  Created by Mohammed Saidam on 22/01/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {
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
        logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        emailFeild.delegate = self
        passwordField.delegate = self
    }
    
    @objc private  func loginButtonTapped(){
        // hidden kwyboard when click login button
        emailFeild.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        guard let email = emailFeild.text,let passsword = passwordField.text,
              !email.isEmpty ,!passsword.isEmpty , passsword.count>=6 else{
            alertUserLoginError()
            return
        }
 
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: passsword ,completion: { [weak self] authResult, error in
            guard let strongSelf = self else{
                return
            }
            
            guard let result = authResult ,error == nil else{
                let image = UIImage(named: "icons8-cancel-50")
                self?.customAlert(messege: "Login Failed", image: image)
                return
            }
            let user = result.user
            let image = UIImage(named: "icons8-done-30")
            self?.customAlert(messege: "Login Successfully", image: image)
            strongSelf.navigationController?.dismiss(animated: true,completion: nil)
            
        })
    }
    //Firebase login
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Oops!", message: "Please enter all information to log in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel,handler: nil))
        present(alert,animated: true)
        
    }
    // This function that push RegisterViewController
    @objc private func DidTapRegister(){
        let vc = RegisterViewController()
        // this code is put title in navigation bar for RegisterViewController
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailFeild{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            loginButtonTapped()
        }
        return true
    }
    
    
    
    
}
extension LoginViewController{
    func customAlert(messege:String ,image:UIImage!){
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .alert)
        
        var imageViewInTitel = UIImageView(image: image)
        imageViewInTitel.frame = CGRect(x: 120, y: 10, width: 30, height: 30)
        alert.view.addSubview(imageViewInTitel)
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        alert.message = "\n \(messege)"
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        
    }
}
