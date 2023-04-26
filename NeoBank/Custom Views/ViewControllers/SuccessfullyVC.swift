//
//  SuccessfullyVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit


class SuccessfullyVC: UIViewController {

  private let imageLogo = UIImageView()
  private let titleText = NBTitleLabel(text: "Congratulations!", textAlignment: .center, fontSize: 30)
  private var secondTitleText = UILabel()
  private let continueButton = NBMainButton(title: "Continue")

  var userID: Int?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    configureSuccessfullyVC()
    configureImageLogo()
    configureTitleText()
    configureSecondTitleText()
    configureContinueButton()
  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }


  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }


  @objc func continueButtonTapped() {
    self.navigationController?.popToRootViewController(animated: true)
  }


  func configureSuccessfullyVC() {
    view.addSubviews(imageLogo, titleText, secondTitleText, continueButton)
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
  }


  func configureImageLogo() {

    imageLogo.translatesAutoresizingMaskIntoConstraints = false
    imageLogo.image = Images.successfullyLogo

    NSLayoutConstraint.activate([
      imageLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageLogo.heightAnchor.constraint(equalToConstant: 200),
      imageLogo.widthAnchor.constraint(equalToConstant: 200)
    ])
  }


  func configureTitleText() {

    NSLayoutConstraint.activate([
      titleText.topAnchor.constraint(equalTo: imageLogo.bottomAnchor, constant: 30),
      titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      titleText.heightAnchor.constraint(equalToConstant: 60)
    ])
  }


  func configureSecondTitleText() {

    guard let userId = userID else {
      return
    }

    secondTitleText = NBSecondTitleLabel(text: "Your NeoBank account \(userId) has been created successfuly" ,textAlignment: .center, fontSize: 17)
    view.addSubview(secondTitleText)
    secondTitleText.translatesAutoresizingMaskIntoConstraints = false
    secondTitleText.numberOfLines = 2

    NSLayoutConstraint.activate([
      secondTitleText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 20),
      secondTitleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      secondTitleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      secondTitleText.heightAnchor.constraint(equalToConstant: 80)
    ])
  }


  func configureContinueButton() {

    continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)

    NSLayoutConstraint.activate([
      continueButton.topAnchor.constraint(equalTo: secondTitleText.bottomAnchor, constant: 40),
      continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      continueButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
}
