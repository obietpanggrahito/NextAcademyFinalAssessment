//
//  MapViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let coordinate = CLLocationCoordinate2D(latitude: 3.134125, longitude: 101.629989)
        let annotation = MapAnnotation(coordinate: coordinate, title: "yea", subtitle: "cmon")
        mapView.addAnnotation(annotation)
        mapView.setRegion(annotation.region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let mkMapView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            mkMapView.animatesWhenAdded = true
            mkMapView.titleVisibility = .adaptive
            mkMapView.subtitleVisibility = .adaptive
            return mkMapView
        }
        return nil
    }
}
