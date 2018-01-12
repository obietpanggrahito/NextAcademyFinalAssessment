//
//  HomeViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var sortSegmentedControl: UISegmentedControl! {
        didSet {
            sortSegmentedControl.addTarget(self, action: #selector(sortSegmentedControlTapped(sender:)), for: .valueChanged)
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchEventsBasedOnRecent()
    }
    
    @objc func sortSegmentedControlTapped(sender: UISegmentedControl) {
        
    }
    
    // MARK: Firebase Call
    func fetchEventsBasedOnRecent() {
        ref.child("events").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.reversed() {
                
                guard let childSnapshot = child as? DataSnapshot,
                let eventDetails = childSnapshot.value as? [String : Any]
                    else { return }
                
                let event = Event(eventDetails: eventDetails)
                self.events.append(event)
                if self.events.count == snapshot.childrenCount {
                    self.eventTableView.reloadData()
                }
            }
        }
    }
    
    func fetchEventsBasedOnLocation() {
        
    }

    @IBAction func addEventBarButtonItemTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension HomeViewController : UITableViewDataSource {
    
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

extension HomeViewController : UITableViewDelegate {
    
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
