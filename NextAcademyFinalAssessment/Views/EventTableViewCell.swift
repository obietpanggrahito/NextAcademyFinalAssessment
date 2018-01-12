//
//  EventTableViewCell.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.contentMode = .scaleAspectFill
            eventImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel! {
        didSet {
            venueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    static let cellIdentifier = "EventTableViewCell"
    static let cellNib = UINib(nibName: EventTableViewCell.cellIdentifier, bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        eventImageView.image = UIImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with event: Event) {
        guard let date = DateFormatterManager.shared.storeDateFormatter.date(from: event.date) else {return}
        monthLabel.text = DateFormatterManager.shared.monthFormatter.string(from: date).uppercased()
        dateLabel.text = DateFormatterManager.shared.dayFormatter.string(from: date)
        
        eventNameLabel.text = event.name
        venueLabel.text = event.venue
        FirebaseStorageManager.shared.getImageFromStorage(event.imageURL) { (image) in
            DispatchQueue.main.async {
                self.eventImageView.image = image
            }
        }
    }
}
