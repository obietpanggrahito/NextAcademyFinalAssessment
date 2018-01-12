//
//  ActivityIndicatorManager.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 12/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit

class ActivityIndicatorManager {
    static var shared = ActivityIndicatorManager()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    
    func presentActivityIndicator(on controller: UIViewController, view: UIView) {
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(white: 0.000, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        controller.view.addSubview(loadingView)
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        controller.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func dismissActivityIndicator() {
        activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
