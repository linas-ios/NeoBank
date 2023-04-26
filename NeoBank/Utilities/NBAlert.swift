//
//  NBAlert.swift
//  NeoBank
//
//  Created by Linas Nutautas on 24/04/2023.
//

import UIKit

class Alert {
  
  static func showAlert(title: String, message: String, on viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
  }
  
}
