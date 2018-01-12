//
//  Events.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation

class Event {
    var id = ""
    var date = ""
    var description = ""
    var imageURL = ""
    var name = ""
    var latitude = 0.0
    var longitude = 0.0
    var timeStamp = 0
    var uid = ""
    var venue = ""
    init() {}
    
    init(id: String, details: [String:Any]) {
        if let date = details["date"] as? String,
            let description = details["description"] as? String,
            let imageURL = details["imageURL"] as? String,
            let name = details["name"] as? String,
            let latitude = details["latitude"] as? Double,
            let longitude = details["longitude"] as? Double,
            let timeStamp = details["timeStamp"] as? Int,
            let uid = details["uid"] as? String,
            let venue = details["venue"] as? String {
            
            self.id = id
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
