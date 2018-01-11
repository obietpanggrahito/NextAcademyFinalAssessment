//
//  MapAnnotation.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var annotationTitle = ""
    var annotationSubtitle = ""
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.annotationTitle = title
        self.annotationSubtitle = subtitle
    }
    
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}
