//
//  SendVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 23/04/2023.
//

import UIKit

import UIKit

class SendVC: BaseViewController {

  let sendMoneyLabel = NBTitleLabel(text: "Send Money", textAlignment: .center, fontSize: 20)
  let senderPhoneNumber = NBSecondTextField(keyboardType: .numberPad, placeholder: "Enter Your Phone number")
  let receiverPhoneNumber = NBSecondTextField(keyboardType: .numberPad, placeholder: "Enter receiver phone number")
  let amount = NBSecondTextField(keyboardType: .numberPad, placeholder: "Enter amount to EUR")
  let comment = NBSecondTextField(keyboardType: .default, placeholder: "Enter comments")
  let sendBotton = NBMainButton(title: "Send")


  var senderAccountId: Int?
  var senderBalance: Double?
  var accessToken: String?
  var completion: ((Double) -> Void)?


  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    sendBotton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    configureSendVC()
  }


  private func configureSendVC() {
    keyboardHeightAdjustment = 0.5
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
  }


  @objc func sendButtonTapped() {

    guard let senderAccountId = senderAccountId else {
      Alert.showAlert(title: "Error", message: "Sender account ID invalid", on: self)
      return
    }

    guard let senderBalance = senderBalance else {
      Alert.showAlert(title: "Error", message: "Sender balance not available", on: self)
      return
    }

    guard let amountText = amount.text, let amountValue = Double(amountText), senderBalance >= amountValue, amountValue > 0 else {
      Alert.showAlert(title: "Error", message: "Invalid amount or insufficient balance", on: self)
        return
    }

    guard let senderPhone = senderPhoneNumber.text, !senderPhone.isEmpty, let receiverPhone = receiverPhoneNumber.text, !receiverPhone.isEmpty else {
      Alert.showAlert(title: "Error", message: "", on: self)
        return
    }

    guard let accessToken = accessToken else {
      print("Wrong Token")
      return
    }


    guard let comment = comment.text, comment.isEmpty else {
      Alert.showAlert(title: "Error", message: "Comments Field Is Empty", on: self)
      return
    }


    let transaction = TransactionRequest(senderPhoneNumber: senderPhone, token: accessToken, receiverPhoneNumber: receiverPhone, senderAccountId: senderAccountId, amount: Double(amountValue), comment: comment)

    Task {
      do {
        let result = try await NetworkManager.shared.sendTransaction(transaction)
        print("Result: \(result)")
        let newBalance = senderBalance - amountValue
        completion?(newBalance)
        self.dismiss(animated: true)
      } catch {
        print("Error: \(error)")
      }
    }
  }


  func setupUI() {
    view.backgroundColor = .white
    view.addSubviews(sendMoneyLabel, senderPhoneNumber, receiverPhoneNumber, amount,comment, sendBotton)

    let padding: CGFloat = 20
    let itemHeight: CGFloat = 50
    let itemWidth: CGFloat = 280

    NSLayoutConstraint.activate([

      sendMoneyLabel.bottomAnchor.constraint(equalTo: receiverPhoneNumber.topAnchor, constant: -padding),
      sendMoneyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      sendMoneyLabel.heightAnchor.constraint(equalToConstant: itemHeight),
      sendMoneyLabel.widthAnchor.constraint(equalToConstant: itemWidth),

      receiverPhoneNumber.bottomAnchor.constraint(equalTo: senderPhoneNumber.topAnchor, constant: -padding),
      receiverPhoneNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      receiverPhoneNumber.heightAnchor.constraint(equalToConstant: itemHeight),
      receiverPhoneNumber.widthAnchor.constraint(equalToConstant: itemWidth),

      senderPhoneNumber.bottomAnchor.constraint(equalTo: amount.topAnchor, constant: -padding),
      senderPhoneNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      senderPhoneNumber.heightAnchor.constraint(equalToConstant: itemHeight),
      senderPhoneNumber.widthAnchor.constraint(equalToConstant: itemWidth),

      amount.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      amount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      amount.heightAnchor.constraint(equalToConstant: itemHeight),
      amount.widthAnchor.constraint(equalToConstant: 280),

      comment.topAnchor.constraint(equalTo: amount.bottomAnchor, constant: padding),
      comment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      comment.heightAnchor.constraint(equalToConstant: itemHeight),
      comment.widthAnchor.constraint(equalToConstant: itemWidth),

      sendBotton.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: padding),
      sendBotton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      sendBotton.heightAnchor.constraint(equalToConstant: itemHeight),
      sendBotton.widthAnchor.constraint(equalToConstant: itemWidth)
    ])
  }
}

