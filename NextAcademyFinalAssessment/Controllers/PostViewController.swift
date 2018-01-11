//
//  PostViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getFormattedDate()
    }
    
    func postNewEvent() {
        
        
        
    }
    
    func getFormattedDate() {
        DateFormatterManager.shared.storeDateFormatter.string(from: Date())
       let date =  DateFormatterManager.shared.storeDateFormatter.date(from: "2018-01-23")
        let dateString = DateFormatterManager.shared.MonthDateFormatter.string(from: date!)
        print(dateString)
    }
}
