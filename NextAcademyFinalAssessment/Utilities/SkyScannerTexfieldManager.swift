//
//  SkyScannerTexfieldManager.swift
//  NextAcademyFinalAssessment
//
//  Created by Obiet Panggrahito on 10/01/2018.
//  Copyright © 2018 Yohan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SkyScannerTextFieldManager  {
    static let shared = SkyScannerTextFieldManager()
    
    func customizeTextField(textField: SkyFloatingLabelTextField, title: String) {
    
        textField.placeholder = title
        textField.placeholderColor = .darkGray
        textField.title = title
        textField.lineColor = .darkGray
        textField.tintColor = #colorLiteral(red: 0.1692255879, green: 0.6514911168, blue: 0.1719624735, alpha: 1)
        textField.selectedLineColor = #colorLiteral(red: 0.1692255879, green: 0.6514911168, blue: 0.1719624735, alpha: 1)
        textField.selectedTitleColor = #colorLiteral(red: 0.1692255879, green: 0.6514911168, blue: 0.1719624735, alpha: 1)
        textField.lineHeight = 1.5
        textField.selectedLineHeight = 2.3
    }
}
