//
//  DetailViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.contentMode = .scaleAspectFill
            eventImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel! {
        didSet {
            venueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
            mapView.addGestureRecognizer(tap)
            mapView.delegate = self
            mapView.isScrollEnabled = false
            mapView.isZoomEnabled = false
        }
    }
    
    @IBOutlet weak var joinButton: UIButton! {
        didSet {
            joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        }
    }
    
    var event = Event()
    var eventImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Event Details"
        setupData()
    }
    
    // MARK: Setups
    func setupData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let date = dateFormatter.date(from: event.date) else { return }
        
        eventNameLabel.text = event.name
        dateLabel.text = DateFormatterManager.shared.showADateFormatter.string(from: date)
        venueLabel.text = event.venue
        descriptionLabel.text = event.description
        
        createAnAnnotation(latitude: event.latitude, longitude: event.longitude)
        FirebaseStorageManager.shared.getImageFromStorage(event.imageURL) { (image) in
            self.eventImageView.image = image
        }
    }
    
    func createAnAnnotation(latitude: Double, longitude: Double) {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MapAnnotation(coordinate: coordinate, title: "yea", subtitle: "cmon")
        mapView.addAnnotation(annotation)
        mapView.setRegion(annotation.region, animated: true)
    }
    
    // MARK: Actions
    @objc func mapViewTapped() {
        let regionDistance :  CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemarks = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemarks)
        mapItem.name = event.venue
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc func joinButtonTapped() {
        
    }
}

extension DetailViewController: MKMapViewDelegate {
    // MARK: Map View Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let marker = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            marker.animatesWhenAdded = true
            marker.isDraggable = false
            return marker
        }
        return nil
    }
}
