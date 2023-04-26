//
//  TopUpMoney.swift
//  NeoBank
//
//  Created by Linas Nutautas on 23/04/2023.
//

import UIKit

class TopUpMoneyVC: BaseViewController {

  let titleLabel = NBTitleLabel(text: "Add Money", textAlignment: .center, fontSize: 20)
  let accountId = NBSecondTextField(keyboardType: .numberPad, placeholder: "Enter Your account ID")
  let amountToAdd = NBSecondTextField(keyboardType: .numberPad, placeholder: "Enter amount to EUR")
  let addButton = NBMainButton(title: "Top Up")

  var completion: ((Double) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
  }


  @objc func addButtonTapped() {

    guard let accountIdText = accountId.text, let accountIdValue = Int(accountIdText) else {
      Alert.showAlert(title: "Error", message: "Invalid account ID", on: self)
      return
    }

    guard let amountToAddText = amountToAdd.text, let amountToAddValue = Double(amountToAddText) else {
      Alert.showAlert(title: "Error", message: "Invalid amount", on: self)
      return
    }


    Task {
      do {
        let response = try await NetworkManager.shared.addMoneyRequest(accountId: accountIdValue , amountToAdd: amountToAddValue )
        print("Add Money: \(response.balance)")
        completion?(response.balance)
        self.dismiss(animated: true)
      } catch {
        print("Error \(error)")
      }
    }
  }


  func setupUI() {
    keyboardHeightAdjustment = 0.1
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
    view.addSubviews(titleLabel, accountId, amountToAdd, addButton)

    addButton.translatesAutoresizingMaskIntoConstraints = false
    amountToAdd.translatesAutoresizingMaskIntoConstraints = false
    accountId.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      amountToAdd.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      amountToAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      amountToAdd.heightAnchor.constraint(equalToConstant: 50),
      amountToAdd.widthAnchor.constraint(equalToConstant: 280),

      accountId.bottomAnchor.constraint(equalTo: amountToAdd.topAnchor, constant: -20),
      accountId.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      accountId.heightAnchor.constraint(equalToConstant: 50),
      accountId.widthAnchor.constraint(equalToConstant: 280),

      addButton.topAnchor.constraint(equalTo: amountToAdd.bottomAnchor, constant: 20),
      addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      addButton.heightAnchor.constraint(equalToConstant: 50),
      addButton.widthAnchor.constraint(equalToConstant: 280),

      titleLabel.bottomAnchor.constraint(equalTo: accountId.topAnchor, constant: -20),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 50),
      titleLabel.widthAnchor.constraint(equalToConstant: 280),
    ])
  }
}
