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
            sortSegmentedControl.addTarget(self, action: #selector(sortSegmentedControlTapped), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var eventTableView: UITableView! {
        didSet {
            eventTableView.dataSource = self
            eventTableView.delegate = self
            eventTableView.tableFooterView = UIView()
            eventTableView.separatorStyle = .none
            eventTableView.register(EventTableViewCell.cellNib, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        }
    }
    
    // MARK: Variables
    var ref = DatabaseReference()
    var events = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchEvents()
    }
    
    @objc func sortSegmentedControlTapped() {
        
    }
    
    // MARK: Firebase Call
    func fetchEvents() {
        //ref.child("events").child(<#T##pathString: String##String#>)
        
        
    }

    @IBAction func addEventBarButtonItemTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellIdentifier) as? EventTableViewCell
            else { return UITableViewCell() }
        
        return cell
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
