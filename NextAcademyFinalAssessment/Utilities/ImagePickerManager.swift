//
//  ImagePickerManager.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 11/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit

class ImagePickerManager {
    static var shared = ImagePickerManager()
    
    func presentImagePickerSheet(on controller: UIViewController) {
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
                                                       message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                                                imagePicker.allowsEditing = true
                                                imagePicker.sourceType = .camera
                                                controller.present(imagePicker,
                                                                   animated: true,
                                                                   completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose From Library",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                                            imagePicker.allowsEditing = true
                                            imagePicker.sourceType = .photoLibrary
                                            controller.present(imagePicker,
                                                               animated: true,
                                                               completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        controller.present(imagePickerActionSheet, animated: true,
                           completion: nil)
    }
}
