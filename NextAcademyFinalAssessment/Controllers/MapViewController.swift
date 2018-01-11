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
    
    @IBOutlet weak var useLocationButton: UIButton! {
        didSet {
            useLocationButton.addTarget(self, action: #selector(useLocationButtonTapped), for: .touchUpInside)
        }
    }
    
    let locationManager = CLLocationManager()
    var selectedLatitude = 0.0
    var selectedLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Venue Location"
        // FIXME: hide the tabbar at the bottom
        setupCLLocationManager()
    }
    
    // MARK: Setups
    func setupCLLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setupStartingLocation(latitude: Double, longitude: Double) {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MapAnnotation(coordinate: coordinate, title: "yea", subtitle: "cmon")
        mapView.addAnnotation(annotation)
        mapView.setRegion(annotation.region, animated: true)
    }
    
    @objc func useLocationButtonTapped() {
        
    }
}

extension MapViewController : CLLocationManagerDelegate {
    
    // MARK: CLLocation Delegate
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            setupStartingLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("User Location Error: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let marker = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            marker.animatesWhenAdded = true
            marker.titleVisibility = .adaptive // FIXME: not showing
            marker.subtitleVisibility = .adaptive
            marker.isDraggable = true
            return marker
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
            guard let droppedAt = view.annotation?.coordinate else { return }
            selectedLatitude = droppedAt.latitude
            selectedLongitude = droppedAt.longitude
        }
    }
}
