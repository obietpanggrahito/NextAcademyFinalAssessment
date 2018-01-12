//
//  DetailViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import MapKit
import Firebase

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
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
            mapView.addGestureRecognizer(tap)
            mapView.delegate = self
            mapView.isScrollEnabled = false
            mapView.isZoomEnabled = false
        }
    }
    
    @IBOutlet weak var joinButton: UIButton!
    
    // MARK: Variables
    var event = Event()
    var eventImage = UIImage()
    var ref = DatabaseReference()
    var currentUserID = ""
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Event Details"
        checkWetherUserJoinedThisEventOrNot()
        setupData()
    }
    
    func checkWetherUserJoinedThisEventOrNot() {
        ref = Database.database().reference()
        guard let currentUserID = Auth.auth().currentUser?.uid
            else { return }
        self.currentUserID = currentUserID
        
        ref.child("users").child(currentUserID).child("joinedEvents").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(self.event.id) {
                self.setupJoinButton(joinedEvent: true)
            }
            else {
                self.setupJoinButton(joinedEvent: false)
            }
        }
    }
    
    // MARK: Setups
    func setupJoinButton(joinedEvent: Bool) {
        if joinedEvent {
            joinButton.setTitle("Cancel", for: .normal)
            joinButton.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
            joinButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
        else {
            joinButton.setTitle("Join", for: .normal)
            joinButton.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.6509803922, blue: 0.1725490196, alpha: 1)
            joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let date = dateFormatter.date(from: event.date) else { return }
        
        eventNameLabel.text = event.name
        dateLabel.text = DateFormatterManager.shared.showADateFormatter.string(from: date)
        venueLabel.text = event.venue
        descriptionLabel.text = event.description
        if event.description == "" {
            descriptionTitleLabel.isHidden = true
        }
        
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
    @objc func cancelButtonTapped() {
        ref.child("users").child(currentUserID).child("joinedEvents").child(event.id).removeValue()
        setupJoinButton(joinedEvent: false)
        reloadProfileTableView()
    }
    
    @objc func joinButtonTapped() {
        let timeStamp = ServerValue.timestamp()
        ref.child("users").child(currentUserID).child("joinedEvents").child(event.id).updateChildValues(["timeStamp": timeStamp])
        setupJoinButton(joinedEvent: true)
        reloadProfileTableView()
    }
    
    func reloadProfileTableView() {
        guard let viewControllers = self.tabBarController?.viewControllers,
        let profileNavigationController = viewControllers[1] as? UINavigationController,
        let profileViewController = profileNavigationController.childViewControllers.first as? ProfileViewController
            else { return }
        
        profileViewController.reloadTableViewFromDetailViewController()
    }
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapViewTapped()
    }
}
