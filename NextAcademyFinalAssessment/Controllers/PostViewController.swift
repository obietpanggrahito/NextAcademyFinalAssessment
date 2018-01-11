//
//  PostViewController.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class PostViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(eventImageViewTapped))
            eventImageView.addGestureRecognizer(tap)
            eventImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var eventNameTextField: SkyFloatingLabelTextField! {
        didSet {
            SkyScannerTextFieldManager.shared.customizeTextField(textField: eventNameTextField, title: "Event Name")
        }
    }
    
    @IBOutlet weak var venueTextField: SkyFloatingLabelTextField! {
        didSet {
            SkyScannerTextFieldManager.shared.customizeTextField(textField: venueTextField, title: "Venue")
        }
    }
    
    @IBOutlet weak var eventDateTextField: SkyFloatingLabelTextField! {
        didSet {
            SkyScannerTextFieldManager.shared.customizeTextField(textField: eventDateTextField, title: "Event Date")
            setupEventDatePicker()
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var publishButton: UIButton! {
        didSet {
            publishButton.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        }
    }
    
    let datePicker = UIDatePicker()
    var choosenDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Setups
    func setupEventDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingDateTapped))
        toolbar.setItems([doneButton], animated: false)
        eventDateTextField.inputAccessoryView = toolbar
        eventDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePickingDateTapped() {
        choosenDate = datePicker.date
        eventDateTextField.text = DateFormatterManager.shared.showADateFormatter.string(from: choosenDate)
        self.view.endEditing(true)
    }
    
    // MARK: Actions
    @objc func eventImageViewTapped() {
        ImagePickerManager.shared.presentImagePickerSheet(on: self)
    }
    
    @objc func publishButtonTapped() {
        
    }
    
    func postNewEvent() {
        
    }
    
    func getFormattedDate() {
        let storedDateString = DateFormatterManager.shared.storeDateFormatter.string(from: Date())
        
        //getting the day and month string from stored dateString.
        
        guard let date = DateFormatterManager.shared.storeDateFormatter.date(from: storedDateString) else {return}
        
        let monthName = DateFormatterManager.shared.monthFormatter.string(from: date)
        
        let day = DateFormatterManager.shared.dayFormatter.string(from: date)

    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Image Picker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            eventImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
