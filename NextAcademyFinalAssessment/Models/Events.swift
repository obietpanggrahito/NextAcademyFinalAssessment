//
//  Events.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation

class Events {
    var eventName = ""
    var venue = ""
    var date = ""
    var eventImageURL = ""
    init() {}
    
    init(eventDetails: [String:Any]) {
        if let eventName = eventDetails["eventName"] as? String,
        let venue = eventDetails["venue"] as? String,
        let date = eventDetails["date"] as? String,
        let eventImageURL = eventDetails["eventImageURL"] as? String {
            
            self.eventName = eventName
            self.venue = venue
            self.date = date
            self.eventImageURL = eventImageURL
        }
    }
}
