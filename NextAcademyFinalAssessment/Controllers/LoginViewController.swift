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
            SkyScannerTextFieldManager.shared.customizeTextField(textField: emailTextField, title: "Email Address")
        }
    }
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField! {
        didSet {
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
    
    // MARK: Variables
    
    
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
    
    // MARK: Actions
    @objc func loginButtonTapped() {
        
    }
    
    @objc func signUpButtonTapped() {
        
    }
}
