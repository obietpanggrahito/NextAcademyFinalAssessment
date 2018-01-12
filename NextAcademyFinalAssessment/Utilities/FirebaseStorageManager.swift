//
//  FirebaseStorageManager.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 12/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseStorageManager {
    static var shared = FirebaseStorageManager()
        
    func uploadImageToStorage(_ image: UIImage, path: String, imageName: String, completionBlock: @escaping (_ url: String?, _ errorMessage: String?) -> Void){
            
        let storageReference = Storage.storage().reference()
        let imagesReference = storageReference.child(path).child(imageName)
            
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
                
            imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL()?.absoluteString, nil)
                }
                else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
        }
        else {
            completionBlock(nil, "Image couldn't be converted to data")
        }
    }
    
    func getImageFromStorage(_ urlString: String, completion: @escaping(UIImage?) -> Void) {
        let imageCache = NSCache<NSString, AnyObject>()
        
        guard let url = URL(string: urlString) else {
            return completion(nil)
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            completion(cachedImage)
            return
        }
        
        DispatchQueue.global().async {
            let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print("error: \(String(describing: error))")
                    return completion(nil)
                }
                guard response != nil else {
                    print("no response")
                    return completion(nil)
                }
                guard data != nil else {
                    print("no data")
                    return completion(nil)
                }
                
                DispatchQueue.main.async {
                    guard let data = data,
                        let image = UIImage(data: data) else{return}
                    imageCache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                }
            }; task.resume()
        }
    }
}
