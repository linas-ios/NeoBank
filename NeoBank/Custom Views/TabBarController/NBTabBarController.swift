//
//  NBTabBarController.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class NBTabBarController: UITabBarController {


  override func viewDidLoad() {
    super.viewDidLoad()
    UITabBar.appearance().tintColor = UIColor(red: 81/255.0, green: 117/255.0, blue: 255/255.0, alpha: 1.0)
    viewControllers = [createHomeNC(),createTransactionNC(), createSettingsNC()]
  }

  func createHomeNC() -> UINavigationController {
    let homeVC = HomeVC()
    homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    return UINavigationController(rootViewController: homeVC)
  }


  func createTransactionNC() -> UINavigationController {
    let transactionVC = TransactionVC()
    transactionVC.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 1)
    return UINavigationController(rootViewController: transactionVC)
  }


  func createSettingsNC() -> UINavigationController {
    let settingsVC = SettingsVC()
    settingsVC.tabBarItem  = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
    return UINavigationController(rootViewController: settingsVC)
  }


}
