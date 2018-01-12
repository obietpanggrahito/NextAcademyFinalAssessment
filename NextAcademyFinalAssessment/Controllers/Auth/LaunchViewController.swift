//
//  LaunchViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 12/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Darwin
import Firebase

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        checkIfSomeoneIsLoggedIn()
    }
    
    func checkIfSomeoneIsLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.directUserToHome()
            }
            else {
                print("User is not authenticated")
                self.directUserToLogin()
            }
        }
    }
    
    func directUserToHome() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            present(controller, animated: true, completion: nil)
        }
    }
    
    func directUserToLogin() {
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        if let controller = authStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            present(controller, animated: true, completion: nil)
        }
    }
}
