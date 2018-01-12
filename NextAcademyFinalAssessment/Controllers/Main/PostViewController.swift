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
            eventNameTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: eventNameTextField, title: "Event Name")
        }
    }
    
    @IBOutlet weak var venueTextField: SkyFloatingLabelTextField! { // FIXME: maybe change this to textview
        didSet {
            venueTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: venueTextField, title: "Venue")
        }
    }
    
    @IBOutlet weak var eventDateTextField: SkyFloatingLabelTextField! {
        didSet {
            eventDateTextField.delegate = self
            SkyScannerTextFieldManager.shared.customizeTextField(textField: eventDateTextField, title: "Event Date")
            setupEventDatePicker()
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBelowDescriptionTextView: UIView!
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
            descriptionTextView.textContainerInset = UIEdgeInsets.zero
            descriptionTextView.textContainer.lineFragmentPadding = 0
        }
    }
    
    @IBOutlet weak var publishButton: UIButton! {
        didSet {
            publishButton.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        }
    }
    
    // MARK: Variables
    let datePicker = UIDatePicker()
    var eventImage = UIImage()
    var choosenDate = Date()
    var venue = ""
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Post"
        setTextViewPlaceHolder(with: descriptionTextView)
    }
    
    // MARK: Setups
    func setupEventDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingDateTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
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
        ActivityIndicatorManager.shared.presentActivityIndicator(on: self, view: self.view)
        
        guard let currentUserID = Auth.auth().currentUser?.uid,
        let eventName = eventNameTextField.text,
        let description = descriptionTextView.text
            else { return }
        
        let timeStamp = ServerValue.timestamp()
        let ref = Database.database().reference()
        let choosenDateInString = DateFormatterManager.shared.storeDateFormatter.string(from: choosenDate)
        
        FirebaseStorageManager.shared.uploadImageToStorage(eventImage, path: "events", imageName: eventName) { (urlString, errorMessage) in
            if errorMessage == nil {
                let post : [String : Any] = ["date": choosenDateInString, "description": description, "imageURL": urlString ?? "http://iosicongallery.com/img/512/eventbrite-2017-04-06.png", "name": eventName, "latitude": self.latitude, "longitude": self.longitude, "timeStamp": timeStamp, "uid": currentUserID, "venue": self.venue]
                ref.child("events").childByAutoId().updateChildValues(post)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    ActivityIndicatorManager.shared.dismissActivityIndicator()
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Image Picker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            eventImageView.contentMode = .scaleAspectFill
            eventImageView.clipsToBounds = true
            eventImageView.image = pickedImage
            eventImage = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: UITextFieldDelegate {
    
    // MARK: Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == venueTextField {
            textField.resignFirstResponder()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let controller = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
                
                controller.getVenueAndLocation = {(venue, latitude, longitude) in
                    self.venue = venue
                    self.latitude = latitude
                    self.longitude = longitude
                    self.venueTextField.text = venue
                }
                self.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(controller, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
}

extension PostViewController: UITextViewDelegate {
    
    // MARK: Text View Delegate
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        descriptionTextViewHeight.constant = size.height + 8
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
            descriptionLabel.isHidden = false
            viewBelowDescriptionTextView.backgroundColor = #colorLiteral(red: 0.168627451, green: 0.6509803922, blue: 0.1725490196, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewBelowDescriptionTextView.backgroundColor = .darkGray
        setTextViewPlaceHolder(with: textView)
    }
    
    func setTextViewPlaceHolder(with sender:UITextView) {
        if sender.text.isEmpty {
            sender.text = "Description"
            sender.textColor = .darkGray
            descriptionLabel.isHidden = true
        }
    }
}
