//
//  AlertManager.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit

class AlertManager {
    static var shared = AlertManager()
    
    func presentDefaultAlert(title: String, message: String, actionTitle: String, on controller: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.destructive, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
