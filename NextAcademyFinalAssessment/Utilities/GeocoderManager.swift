//
//  GeocoderManager.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 12/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation
import CoreLocation

class GeocoderManager {
    static var shared = GeocoderManager()
    
    func getAddressFromALocation(location: CLLocation, completion: @escaping(String) -> ()) { //Some people use CLLocation
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Get Address Error: \(error)")
            }
            else if let state = placemarks?.first?.administrativeArea,
            let city = placemarks?.first?.locality,
            let street = placemarks?.first?.thoroughfare {
                let address = "\(street), \(city), \(state)"
                completion(address)
            }
        }
    }
    
    func getLocationFromAnAddress(address: String, completion: @escaping(CLLocation) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks,
            let location = placemarks.first?.location {
                completion(location)
            }
            else {
                print("Get Location Error: \(String(describing: error))")
            }
        }
    }
}
