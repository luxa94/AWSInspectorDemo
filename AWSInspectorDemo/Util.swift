//
//  Util.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/19/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import Foundation
import UIKit

func showSimpleAlertWithTitle(message: String, viewController: UIViewController, action: ((UIAlertAction?) -> Void)? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: "¯\\_(ツ)_/¯", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: action)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}

