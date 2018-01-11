//
//  SignUpViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 10/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField! {
        didSet {
            firstNameTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: firstNameTextField, title: "First Name")
        }
    }
    
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField! {
        didSet {
            lastNameTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: lastNameTextField, title: "Last Name")
        }
    }
    
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
    
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
            createAccountButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Creating Account Proccess
    @objc func createAccountButtonTapped() {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        if email == "" || password == "" || firstName == "" || lastName == "" {
            AlertManager.shared.presentDefaultAlert(title: "Sign Up Error", message: "Please key in all details", actionTitle: "OK", on: self)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil  {
                AlertManager.shared.presentDefaultAlert(title: "Sign Up Error", message: "\(String(describing: error?.localizedDescription))", actionTitle: "OK", on: self)
            }
            else {
                self.writeToFirebase(firstname: firstName, lastName: lastName, email: email)
            }
        })
    }
    
    func writeToFirebase(firstname: String, lastName: String, email: String) {
        let ref = Database.database().reference()
        let userInfo = ["firstName" : firstname, "lastName": lastName, "email" : email]
        guard let currentUserID = Auth.auth().currentUser?.uid
            else { return }
        
        ref.child("users").child(currentUserID).child("userInfo").updateChildValues(userInfo)
        self.directUserToListingViewController()
    }
    
    func directUserToListingViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            present(controller, animated: true, completion: nil)
        }
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
    // MARK: Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        else {
            if textField.returnKeyType == UIReturnKeyType.go {
                createAccountButtonTapped()
            }
            else {
                textField.resignFirstResponder()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                
                if textField == emailTextField {
                    if text.count < 3 || !text.contains("@") {
                        floatingLabelTextField.errorMessage = "Invalid Email Address"
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
                else if textField == passwordTextField {
                    if text.count < 5 {
                        floatingLabelTextField.errorMessage = "Password is too short"
                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if emailTextField.text != "" && passwordTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {
            createAccountButton.isEnabled = true
            createAccountButton.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.6509803922, blue: 0.1725490196, alpha: 1)
        }
        else {
            createAccountButton.isEnabled = false
            createAccountButton.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.6509803922, blue: 0.1725490196, alpha: 0.3005672089)
        }
    }
}
