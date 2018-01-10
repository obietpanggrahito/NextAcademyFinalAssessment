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
}

