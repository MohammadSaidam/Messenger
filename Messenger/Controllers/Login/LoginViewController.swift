//
//  LoginViewController.swift
//  Messenger
//
//  Created by Mohammed Saidam on 22/01/2023.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FacebookCore

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
    private let facbookLoginButton:FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        
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
        
        
        scrollView.addSubview(facbookLoginButton)
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
                                   y:passwordField.bottom+10 ,
                                   width: scrollView.width-60,
                                   height: 50)
        facbookLoginButton.frame = CGRect(x: 30,
                                          y:logInButton.bottom+30 ,
                                          width: scrollView.width-60,
                                          height: 50)
        
        
        
        emailFeild.delegate = self
        passwordField.delegate = self
        facbookLoginButton.delegate = self
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
extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // No operation
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else{
            print("User Failed to login using Facebook")
            print("the Error is\(error)")
            return
        }
        let facebookRequest = FacebookLogin.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil, httpMethod: .get
        )
        facebookRequest.start(completionHandler: { _, result , error in
            guard let result = result as? [String : Any] , error == nil else{
                print("Failed to make facebook graph request")
                return
            }
            print("\(result)")
            guard let userName = result["name"] as? String , let email = result["email"] as? String else{
                print("Failed to get name and email from the Facebook result")
                return
            }
            let nameComponent = userName.components(separatedBy: " ")
            guard nameComponent.count == 2 else{
                return
            }
            let firstName = nameComponent[0]
            let lastName = nameComponent[1]
            
            DatabaseManager.shared.userExist(email: email) { exists in
                if !exists{
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, email: email))
                }
            }
            
            // This code that Access Token Facebook
            let credential  = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with:credential,completion: {[weak self] authResult, error in
                guard let StringSelf = self else{
                    return
                }
                guard  authResult != nil, error == nil else {
                    print("Facebook credential login failed")
                    return
                }
                print("Successfully logged user in")
                StringSelf.navigationController?.dismiss(animated: true,completion: nil)
            })
            
            
        })
        
        
        
    }
    
    
}
