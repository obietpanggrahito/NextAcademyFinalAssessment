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
    
    @IBOutlet weak var venueTextField: SkyFloatingLabelTextField! {
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
    
    let datePicker = UIDatePicker()
    var choosenDate = Date()
    
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
            eventImageView.contentMode = .scaleAspectFill
            eventImageView.image = pickedImage
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
                navigationController?.pushViewController(controller, animated: true)
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
