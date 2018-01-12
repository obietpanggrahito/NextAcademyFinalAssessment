//
//  User.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 12/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation

class Profile {
    var email = ""
    var firstName = ""
    var lastName = ""
    var imageURL = ""
    init() {}
    
    init(details: [String : Any]) {
        if let email = details["email"] as? String,
        let firstName = details["firstName"] as? String,
        let lastName = details["lastName"] as? String,
        let imageURL = details["imageURL"] as? String {
            
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.imageURL = imageURL
        }
    }
}
