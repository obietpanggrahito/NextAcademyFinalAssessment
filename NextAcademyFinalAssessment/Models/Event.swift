//
//  Events.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation

class Event {
    var date = ""
    var description = ""
    var imageURL = ""
    var name = ""
    var latitude = 0.0
    var longitude = 0.0
    var timeStamp = ""
    var uid = ""
    var venue = ""
    init() {}
    
    init(eventDetails: [String:Any]) {
        if let date = eventDetails["date"] as? String,
            let description = eventDetails["description"] as? String,
            let imageURL = eventDetails["imageURL"] as? String,
            let name = eventDetails["name"] as? String,
            let latitude = eventDetails["latitude"] as? Double,
            let longitude = eventDetails["longitude"] as? Double,
            let timeStamp = eventDetails["timeStamp"] as? String,
            let uid = eventDetails["uid"] as? String,
            let venue = eventDetails["venue"] as? String {
            
            self.date = date
            self.description = description
            self.imageURL = imageURL
            self.name = name
            self.latitude = latitude
            self.longitude = longitude
            self.timeStamp = timeStamp
            self.uid = uid
            self.venue = venue
        }
    }
}
