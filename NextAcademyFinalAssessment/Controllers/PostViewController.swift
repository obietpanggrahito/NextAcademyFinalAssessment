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
        let storedDateString = DateFormatterManager.shared.storeDateFormatter.string(from: Date())
        
        //MARK: getting the day and month string from stored dateString.
        
        guard let date = DateFormatterManager.shared.storeDateFormatter.date(from: storedDateString) else {return}
        
        let monthName = DateFormatterManager.shared.monthFormatter.string(from: date)
        
        let day = DateFormatterManager.shared.dayFormatter.string(from: date)

    }
}
