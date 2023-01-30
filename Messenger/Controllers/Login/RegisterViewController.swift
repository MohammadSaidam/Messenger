//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Mohammed Saidam on 22/01/2023.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    
    private var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private var imageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        return imageView
        
    }()
    private var firstNameField:UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1 //means 1px
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "first Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
        
    }()
    private var lastNameField:UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1 //means 1px
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "last Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
        
    }()
    private var emailFeild:UITextField = {
        var field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
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
    
    private var registerButton:UIButton = {
        var button = UIButton()
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemGreen // background button
        button.setTitleColor(.white, for: .normal)// color of login word
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold) // type of font style bold or italic ect.
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        self.view.backgroundColor = .white
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
        //                                                            style: .done, target: self,
        //                                                            action: #selector(DidTapRegister))
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        // Add SubViews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailFeild)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePhoto))
        // gesture.numberOfTouchesRequired =
        imageView.addGestureRecognizer(gesture)
    }
    @objc private func didTapChangeProfilePhoto(){
        presentPhotoActionSheet()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/4
        imageView.frame = CGRect(x: (scrollView.width-size)/2,y:20,width: scrollView.width/4,height: scrollView.width/4)
        imageView.layer.cornerRadius = imageView.width/2.0
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom+18, width: scrollView.width-60, height: 50)
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom+18, width: scrollView.width-60, height: 50)
        emailFeild.frame = CGRect(x: 30,y:lastNameField.bottom+18,width: scrollView.width-60,height:50)
        passwordField.frame = CGRect(x: 30,y:emailFeild.bottom+18 ,width: scrollView.width-60,height: 50)
        registerButton.frame = CGRect(x: 30,  y:passwordField.bottom+20 ,width: scrollView.width-60,height: 50)
        
        emailFeild.delegate = self
        passwordField.delegate = self
    }
    
    @objc private  func registerButtonTapped(){
        // hidden Keyboard
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailFeild.resignFirstResponder()
        passwordField.resignFirstResponder()
        // Validation textFeild
        guard let firstName = firstNameField.text,let lastName = lastNameField.text,
              let email = emailFeild.text,let passsword = passwordField.text,
              !firstName.isEmpty,!lastName.isEmpty,
              !email.isEmpty ,!passsword.isEmpty , passsword.count>=6 else{
            alertUserLoginError()
            return
        }
        DatabaseManager.shared.userExist(email: email, completion: { [weak self] exists in
            guard let strongSelf = self else{
                
                return
            }
            
            guard !exists else{
                // User already exists
                strongSelf.alertUserLoginError(messege: "Looks like a user account for that email address already exists.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: passsword ,completion: {  authResult, error in
           
                
                guard authResult != nil, error == nil else{
                    let image = UIImage(named: "icons8-cancel-50")
                    self?.customAlert(messege: "Addedd is Failed", image: image)
                    return
                }
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, email: email))
                let image = UIImage(named: "icons8-done-30")
                self?.customAlert(messege: "Addedd Successfully", image: image)
                strongSelf.navigationController?.dismiss(animated: true,completion: nil)
                
                
            })
            
        })
        
    }
    //Firebase login
    
    
    func alertUserLoginError(messege:String = "Please enter all information to create a new account"){
        let alert = UIAlertController(title: "Oops!", message: messege, preferredStyle: .alert)
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
            registerButtonTapped()
        }
        return true
    }
    
    
    
    
    
}
extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    // this function that select image from library
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Hoe would you like to select a picture?", preferredStyle: .actionSheet)
        // add three buttons in actionSheet
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default,handler: { [weak self] _ in
            
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default,handler: { [weak self] _ in
            self?.presentPhotoPiker()
            
        }))
        present(actionSheet, animated: true)
    }
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        // view tje image
        present(vc, animated: true)
        
    }
    func presentPhotoPiker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        // view tje image
        present(vc, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true,completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as?UIImage else{
            return
        }
        self.imageView.image = selectedImage
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
        
    }
    func customAlert(messege:String ,image:UIImage!){
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .alert)
        
        var imageViewInTitel = UIImageView(image: image)
        imageViewInTitel.frame = CGRect(x: 120, y: 10, width: 30, height: 30)
        alert.view.addSubview(imageViewInTitel)
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 10
        alert.message = "\n \(messege)"
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
}
