//
//  SettingsVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class SettingsVC: BaseViewController {

  let titleLabel = NBTitleLabel(text: "Settings", textAlignment: .center, fontSize: 30)

  let avatarImage = BNAvatarImageView(frame: .zero)
  let accountIdLabel = NBTitleLabel(text: "accountID", textAlignment: .center, fontSize: 20)

  let currentPhoneLabel = NBBodyLabel(text: "Enter current phone number", textAlignment: .left, fontSize: 12)
  let currentPhoneCV = ContainerView()
  let currentPhoneImage = UIImageView()
  let currentPhoneField = NBMainTextField(keyboardType: .numberPad)

  let newPhoneLabel = NBBodyLabel(text: "Enter new phone number", textAlignment: .left, fontSize: 12)
  let newPhoneCV = ContainerView()
  let newPhoneImage = UIImageView()
  let newPhoneField = NBMainTextField(keyboardType: .numberPad)

  let newPasswordLabel = NBBodyLabel(text: "Enter new password", textAlignment: .left, fontSize: 12)
  let newPasswordCV = ContainerView()
  let newPasswordImage = UIImageView()
  let newPasswordField = NBMainTextField(keyboardType: .default)

  let saveButton = NBMainButton(title: "Save")

  var currentBalance: Double?
  var accountId: Int?
  var userToken: String?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubviews(titleLabel, avatarImage, accountIdLabel, currentPhoneLabel, currentPhoneCV, currentPhoneImage, currentPhoneField, newPhoneLabel, newPhoneCV, newPhoneImage, newPhoneField, newPasswordLabel, newPasswordCV, newPasswordImage, newPasswordField, saveButton)

    configureSettingsVC()
    configureNavigationItem()

    configureTitleLabel()
    configureAvatarImage()
    configureAccountId()

    configureCurrentPhoneLabel()
    configureCurrentPhoneField()

    configureNewPhoneLabel()
    configureNewPhoneField()

    configureNewPasswordLabel()
    configureNewPasswordField()

    configureSaveButton()
  }
  

  @objc func saveButtonTapped() {

    Task {
      do {
        let requestBody = UpdateUserRequest(currentPhoneNumber: currentPhoneField.text! , newPhoneNumber: newPhoneField.text!, newPassword: newPasswordField.text!, token: userToken ?? "No Token")
        let response = try await NetworkManager.shared.updateUser(requestBody: requestBody)
        print("User updated successfully: \(response)")

        logOutAndPresentOnBoarding()
      } catch {
        print("Error")
      }
    }
  }


  @objc func logOutAndPresentOnBoarding() {
    UserDefaults.standard.removeObject(forKey: "accessToken")
    UserDefaults.standard.removeObject(forKey: "validUntil")

    let onBoardingVC = OnBoardingVC()
    let navigationVC = UINavigationController(rootViewController: onBoardingVC)
    navigationVC.modalPresentationStyle = .fullScreen
    self.present(navigationVC, animated: true, completion: nil)
  }


  private func configureSettingsVC() {
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
    keyboardHeightAdjustment = 0.7
  }


  private func configureNavigationItem() {
    let logoutButton = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOutAndPresentOnBoarding))
    logoutButton.image = UIImage(systemName: "power.circle")
    logoutButton.tintColor = .red
    navigationItem.rightBarButtonItem = logoutButton
  }


  private func configureTitleLabel() {

    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      titleLabel.heightAnchor.constraint(equalToConstant: 32)
    ])
  }


  private func configureAvatarImage() {

    avatarImage.image = Images.placeholder
    avatarImage.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      avatarImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      avatarImage.heightAnchor.constraint(equalToConstant: 100),
      avatarImage.widthAnchor.constraint(equalToConstant: 100)
    ])
  }


  private func configureAccountId() {

    guard let accountId = accountId else { return }

    accountIdLabel.text = "Accound ID: \(accountId)"
    accountIdLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      accountIdLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
      accountIdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      accountIdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      accountIdLabel.heightAnchor.constraint(equalToConstant: 22)
    ])
  }


  private func configureCurrentPhoneLabel() {

    currentPhoneLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      currentPhoneLabel.topAnchor.constraint(equalTo: accountIdLabel.bottomAnchor, constant: 50),
      currentPhoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      currentPhoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      currentPhoneLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }


  private func configureCurrentPhoneField() {

    currentPhoneImage.image = Images.flag

    currentPhoneImage.translatesAutoresizingMaskIntoConstraints = false
    currentPhoneField.translatesAutoresizingMaskIntoConstraints = false
    currentPhoneCV.addSubview(currentPhoneImage)
    currentPhoneCV.addSubview(currentPhoneField)

    NSLayoutConstraint.activate([
      currentPhoneCV.topAnchor.constraint(equalTo: currentPhoneLabel.bottomAnchor, constant: 8),
      currentPhoneCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      currentPhoneCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      currentPhoneCV.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      currentPhoneField.topAnchor.constraint(equalTo: currentPhoneCV.topAnchor, constant: 7),
      currentPhoneField.trailingAnchor.constraint(equalTo: currentPhoneCV.trailingAnchor, constant: -7),
      currentPhoneField.bottomAnchor.constraint(equalTo: currentPhoneCV.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      currentPhoneImage.centerYAnchor.constraint(equalTo: currentPhoneCV.centerYAnchor),
      currentPhoneImage.leadingAnchor.constraint(equalTo: currentPhoneCV.leadingAnchor, constant: 15),
      currentPhoneImage.widthAnchor.constraint(equalToConstant: 20),
      currentPhoneImage.heightAnchor.constraint(equalToConstant: 20)
    ])

    currentPhoneField.leadingAnchor.constraint(equalTo: currentPhoneImage.trailingAnchor, constant: 15).isActive = true
  }


  private func configureNewPhoneLabel() {

    newPhoneLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      newPhoneLabel.topAnchor.constraint(equalTo: currentPhoneCV.bottomAnchor, constant: 20),
      newPhoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      newPhoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      newPhoneLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }


  private func configureNewPhoneField() {

    newPhoneImage.image = Images.flag

    newPhoneImage.translatesAutoresizingMaskIntoConstraints = false
    newPhoneField.translatesAutoresizingMaskIntoConstraints = false
    newPhoneCV.addSubview(newPhoneImage)
    newPhoneCV.addSubview(newPhoneField)

    NSLayoutConstraint.activate([
      newPhoneCV.topAnchor.constraint(equalTo: newPhoneLabel.bottomAnchor, constant: 8),
      newPhoneCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      newPhoneCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      newPhoneCV.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      newPhoneField.topAnchor.constraint(equalTo: newPhoneCV.topAnchor, constant: 7),
      newPhoneField.trailingAnchor.constraint(equalTo: newPhoneCV.trailingAnchor, constant: -7),
      newPhoneField.bottomAnchor.constraint(equalTo: newPhoneCV.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      newPhoneImage.centerYAnchor.constraint(equalTo: newPhoneCV.centerYAnchor),
      newPhoneImage.leadingAnchor.constraint(equalTo: newPhoneCV.leadingAnchor, constant: 15),
      newPhoneImage.widthAnchor.constraint(equalToConstant: 20),
      newPhoneImage.heightAnchor.constraint(equalToConstant: 20)
    ])

    newPhoneField.leadingAnchor.constraint(equalTo: newPhoneImage.trailingAnchor, constant: 15).isActive = true
  }


  private func configureNewPasswordLabel() {

    newPasswordLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      newPasswordLabel.topAnchor.constraint(equalTo: newPhoneCV.bottomAnchor, constant: 20),
      newPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      newPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      newPasswordLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }


  private func configureNewPasswordField() {

    newPasswordImage.image = Images.eye
    newPasswordImage.tintColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)

    newPasswordImage.translatesAutoresizingMaskIntoConstraints = false
    newPasswordField.translatesAutoresizingMaskIntoConstraints = false
    newPasswordCV.addSubview(newPasswordImage)
    newPasswordCV.addSubview(newPasswordField)

    NSLayoutConstraint.activate([
      newPasswordCV.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 8),
      newPasswordCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      newPasswordCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      newPasswordCV.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      newPasswordField.topAnchor.constraint(equalTo: newPasswordCV.topAnchor, constant: 7),
      newPasswordField.trailingAnchor.constraint(equalTo: newPasswordCV.trailingAnchor, constant: -7),
      newPasswordField.bottomAnchor.constraint(equalTo: newPasswordCV.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      newPasswordImage.centerYAnchor.constraint(equalTo: newPasswordCV.centerYAnchor),
      newPasswordImage.leadingAnchor.constraint(equalTo: newPasswordCV.leadingAnchor, constant: 15),
      newPasswordImage.widthAnchor.constraint(equalToConstant: 20),
      newPasswordImage.heightAnchor.constraint(equalToConstant: 20)
    ])

    newPasswordField.leadingAnchor.constraint(equalTo: newPasswordImage.trailingAnchor, constant: 15).isActive = true
  }

  private func configureSaveButton() {

    saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

    saveButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      saveButton.topAnchor.constraint(equalTo: newPasswordCV.bottomAnchor, constant: 40),
      saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      saveButton.heightAnchor.constraint(equalToConstant: 45)
    ])
  }
}
