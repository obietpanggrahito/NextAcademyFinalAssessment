//
//  ProfileViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.masksToBounds = true
            userImageView.layer.cornerRadius = userImageView.frame.width/2
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var eventTableView: UITableView! {
        didSet {
            eventTableView.dataSource = self
            eventTableView.delegate = self
            eventTableView.separatorStyle = .none
            eventTableView.tableFooterView = UIView()
            
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 13))
            footer.backgroundColor = UIColor.groupTableViewBackground
            eventTableView.tableFooterView = footer
            eventTableView.register(EventTableViewCell.cellNib, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)

        }
    }
    
    // MARK: Variables
    var ref = DatabaseReference()
    var events = [Event]()
    var currentUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDetails()
        fetchJoinedEventID()
    }
    
    // MARK: Fetch UserDetails
    func fetchUserDetails() {
        ref = Database.database().reference()
        guard let currentUserID = Auth.auth().currentUser?.uid
            else { return }
        self.currentUserID = currentUserID
        
        ref.child("users").child(currentUserID).child("userInfo").observeSingleEvent(of: .value) { (snapshot) in
            guard let userDetail = snapshot.value as? [String : Any] else { return }
            let profile = Profile(details: userDetail)
            self.setupProfile(profile: profile)
        }
    }
    
    func setupProfile(profile: Profile) {
        nameLabel.text = "\(profile.firstName) \(profile.lastName)"
        emailLabel.text = profile.email
        FirebaseStorageManager.shared.getImageFromStorage(profile.imageURL) { (image) in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
    }
    
    // MARK: Fetch Events
    func fetchJoinedEventID() {
        ref.child("users").child(currentUserID).child("joinedEvents").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.reversed() {
                guard let childSnapshot = child as? DataSnapshot else { return }
                let eventID = childSnapshot.key
                self.fetchJoinedEventDetails(eventID: eventID)
            }
        }
    }
    
    func fetchJoinedEventDetails(eventID: String) {
        ref.child("events").child(eventID).observeSingleEvent(of: .value) { (snapshot) in
            guard let eventDetails = snapshot.value as? [String : Any] else { return }
            let eventID = snapshot.key
            
            let event = Event(id: eventID, details: eventDetails)
            self.events.append(event)
            if self.events.count == snapshot.childrenCount {
                self.eventTableView.reloadData()
            }
        }
    }
}

extension ProfileViewController : UITableViewDataSource {
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellIdentifier) as? EventTableViewCell
            else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.configureCell(with: events[indexPath.row])
        return cell
    }
}

extension ProfileViewController : UITableViewDelegate {
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            
            controller.event = events[indexPath.row]
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
}

