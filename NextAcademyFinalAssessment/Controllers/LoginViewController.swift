//
//  LoginViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 10/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField! {
        didSet {
            emailTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: emailTextField, title: "Email Address")
        }
    }
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField! {
        didSet {
            passwordTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: passwordTextField, title: "Password")
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            setupSignUpButton()
            signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Setups
    func setupSignUpButton() {
        let stringContent = NSMutableAttributedString.init(string: "Don't have an account yet? Sign Up")
        let stringFont =  UIFont.systemFont(ofSize: 17, weight: .bold)
        let greenColor = #colorLiteral(red: 0.168627451, green: 0.6509803922, blue: 0.1725490196, alpha: 1)
        
        stringContent.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], range: NSMakeRange(0, 26))
        stringContent.setAttributes([NSAttributedStringKey.font: stringFont, NSAttributedStringKey.foregroundColor: greenColor], range: NSMakeRange(27, 7))
        signUpButton.setAttributedTitle(stringContent, for: .normal)
    }
    
    @objc func signUpButtonTapped() {
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        if let controller = authStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: Login Proccess
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        if email == "" || password == "" {
            AlertManager.shared.presentDefaultAlert(title: "Login Error", message: "Email / password cannot be empty", actionTitle: "OK", on: self)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().signIn(with: credential, completion: { (user: User?, error: Error?) in
            if user != nil {
                self.directUserToListingViewController()
            }
            else {
                AlertManager.shared.presentDefaultAlert(title: "Login Error", message: "\(error?.localizedDescription ?? "Please try again")", actionTitle: "OK", on: self)
            }
        })
    }
    
    func directUserToListingViewController() {
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    // MARK: Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        else {
            if textField.returnKeyType == UIReturnKeyType.go {
                loginButtonTapped()
            }
            else {
                textField.resignFirstResponder()
            }
        }
        return false
    }
}

