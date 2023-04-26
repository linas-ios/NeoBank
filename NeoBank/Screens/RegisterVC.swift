//
//  RegisterVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class RegisterVC: BaseViewController {

  let titleLabel = NBTitleLabel(text: "Registration", textAlignment: .center, fontSize: 30)
  let phoneContainerView = ContainerView()
  let phoneCustomImage = UIImageView()
  let phoneLabel = NBBodyLabel(text: "Enter mobile number", textAlignment: .left, fontSize: 12)
  let phoneTextField = NBMainTextField(keyboardType: .numberPad)

  let passwordContainerView = ContainerView()
  let passwordCustomImage = UIImageView()
  let passwordLabel = NBBodyLabel(text: "Enter password", textAlignment: .left, fontSize: 12)
  let passwordTextField = NBMainTextField(keyboardType: .default)

  let confirmpassContainerView = ContainerView()
  let confirmpassCustomImage = UIImageView()
  let confirmpassLabel = NBBodyLabel(text: "Confirm password", textAlignment: .left, fontSize: 12)
  let confirmpassTextField = NBMainTextField(keyboardType: .default)

  let currencyContainerView = ContainerView()
  let currencyCustomImage = UIImageView()
  let currencyLabel = NBBodyLabel(text: "Enter currency", textAlignment: .left, fontSize: 12)
  let currencyTextField = NBMainTextField(keyboardType: .default)

  let signUpButton = NBMainButton(title: "Sign Up")
  let goBackButton = NBMainButton(title: "Back")


  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubviews(titleLabel, phoneContainerView, phoneLabel, phoneTextField, passwordContainerView, passwordCustomImage, passwordLabel, passwordTextField, confirmpassContainerView, confirmpassCustomImage, confirmpassLabel, confirmpassTextField, currencyContainerView, currencyCustomImage, currencyLabel, currencyTextField ,signUpButton, goBackButton)

    configureLoginVC()
    configureTitleLabel()
    configurePhoneLabel()
    configurePhoneTextField()
    configurePasswordLabel()
    configurePasswordTextField()
    configureConfirmPassLabel()
    configureConfirmPassTextField()
    configureSignUpButton()
    configureGoBackButton()
    configureCurrencyLabel()
    configureCurrencyTextField()
  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }


  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }


  @objc func goBackButtonTapped() {
    navigationController?.popViewController(animated: true)
  }


  func isPasswordValid() -> Bool {
    guard passwordTextField.text == confirmpassTextField.text else {
      Alert.showAlert(title: "Error", message: "Paswords do not match", on: self)
      return false
    }
    return true
  }


  @objc func callSignUpButton() {

    guard isPasswordValid() else { return }

    guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
      Alert.showAlert(title: "Erro", message: "Please enter phone number", on: self)
      return
    }

    guard let password = passwordTextField.text, !password.isEmpty else {
      Alert.showAlert(title: "Error", message: "Please enter password", on: self)
      return
    }

    guard let currency = currencyTextField.text, !currency.isEmpty else {
      Alert.showAlert(title: "Error", message: "Please enter currency", on: self)
      return
    }

    Task {
      do {
        let response = try await NetworkManager.shared.registerRequest(phoneNumber: phoneNumber, password: password, currency: currency)
        let successVC = SuccessfullyVC()
        successVC.userID = response.userId
        navigationController?.pushViewController(successVC, animated: true)
      } catch {
        Alert.showAlert(title: "Error", message: "Registration failed. Please try again", on: self)
      }
    }
  }


  func configureLoginVC() {
    keyboardHeightAdjustment = 0.5
    view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 254/255.0, alpha: 1)
  }


  func configureTitleLabel() {

    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      titleLabel.heightAnchor.constraint(equalToConstant: 42)
    ])
  }

  func configurePhoneLabel() {

    phoneLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      phoneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
      phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      phoneLabel.heightAnchor.constraint(equalToConstant: 13)
    ])
  }


  func configurePhoneTextField() {

    phoneCustomImage.image = Images.flag

    phoneCustomImage.translatesAutoresizingMaskIntoConstraints = false
    phoneTextField.translatesAutoresizingMaskIntoConstraints = false
    phoneContainerView.addSubview(phoneCustomImage)
    phoneContainerView.addSubview(phoneTextField)

    NSLayoutConstraint.activate([
      phoneContainerView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
      phoneContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      phoneContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      phoneContainerView.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      phoneTextField.topAnchor.constraint(equalTo: phoneContainerView.topAnchor, constant: 7),
      phoneTextField.trailingAnchor.constraint(equalTo: phoneContainerView.trailingAnchor, constant: -7),
      phoneTextField.bottomAnchor.constraint(equalTo: phoneContainerView.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      phoneCustomImage.centerYAnchor.constraint(equalTo: phoneContainerView.centerYAnchor),
      phoneCustomImage.leadingAnchor.constraint(equalTo: phoneContainerView.leadingAnchor, constant: 15),
      phoneCustomImage.widthAnchor.constraint(equalToConstant: 20),
      phoneCustomImage.heightAnchor.constraint(equalToConstant: 20)
    ])

    phoneTextField.leadingAnchor.constraint(equalTo: phoneCustomImage.trailingAnchor, constant: 15).isActive = true
  }


  func configurePasswordLabel() {

    passwordLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      passwordLabel.topAnchor.constraint(equalTo: phoneContainerView.bottomAnchor, constant: 20),
      passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }


  func configurePasswordTextField() {

    passwordCustomImage.image = Images.eye
    passwordCustomImage.tintColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)

    passwordCustomImage.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false

    passwordContainerView.addSubview(passwordCustomImage)
    passwordContainerView.addSubview(passwordTextField)

    NSLayoutConstraint.activate([
      passwordContainerView.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
      passwordContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      passwordContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      passwordContainerView.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      passwordTextField.topAnchor.constraint(equalTo: passwordContainerView.topAnchor, constant: 7),
      passwordTextField.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -7),
      passwordTextField.bottomAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      passwordCustomImage.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
      passwordCustomImage.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 15),
      passwordCustomImage.widthAnchor.constraint(equalToConstant: 25),
      passwordCustomImage.heightAnchor.constraint(equalToConstant: 20)
    ])

    passwordTextField.leadingAnchor.constraint(equalTo: passwordCustomImage.trailingAnchor, constant: 15).isActive = true
  }


  func configureConfirmPassLabel() {

    confirmpassLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      confirmpassLabel.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 20),
      confirmpassLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      confirmpassLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }


  func configureConfirmPassTextField() {

    confirmpassCustomImage.image = Images.eye
    confirmpassCustomImage.tintColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)

    confirmpassCustomImage.translatesAutoresizingMaskIntoConstraints = false
    confirmpassTextField.translatesAutoresizingMaskIntoConstraints = false

    confirmpassContainerView.addSubview(confirmpassCustomImage)
    confirmpassContainerView.addSubview(confirmpassTextField)

    NSLayoutConstraint.activate([
      confirmpassContainerView.topAnchor.constraint(equalTo: confirmpassLabel.bottomAnchor, constant: 8),
      confirmpassContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      confirmpassContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      confirmpassContainerView.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      confirmpassTextField.topAnchor.constraint(equalTo: confirmpassContainerView.topAnchor, constant: 7),
      confirmpassTextField.trailingAnchor.constraint(equalTo: confirmpassContainerView.trailingAnchor, constant: -7),
      confirmpassTextField.bottomAnchor.constraint(equalTo: confirmpassContainerView.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      confirmpassCustomImage.centerYAnchor.constraint(equalTo: confirmpassContainerView.centerYAnchor),
      confirmpassCustomImage.leadingAnchor.constraint(equalTo: confirmpassContainerView.leadingAnchor, constant: 15),
      confirmpassCustomImage.widthAnchor.constraint(equalToConstant: 25),
      confirmpassCustomImage.heightAnchor.constraint(equalToConstant: 20)
    ])

    confirmpassTextField.leadingAnchor.constraint(equalTo: confirmpassCustomImage.trailingAnchor, constant: 15).isActive = true
  }


  func configureCurrencyLabel() {

    currencyLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      currencyLabel.topAnchor.constraint(equalTo: confirmpassContainerView.bottomAnchor, constant: 20),
      currencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      currencyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }

  func configureCurrencyTextField() {

    currencyCustomImage.image = Images.euro
    currencyCustomImage.tintColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)

    currencyCustomImage.translatesAutoresizingMaskIntoConstraints = false
    currencyTextField.translatesAutoresizingMaskIntoConstraints = false

    currencyContainerView.addSubview(currencyCustomImage)
    currencyContainerView.addSubview(currencyTextField)

    NSLayoutConstraint.activate([
      currencyContainerView.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 8),
      currencyContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      currencyContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      currencyContainerView.heightAnchor.constraint(equalToConstant: 50)
    ])

    NSLayoutConstraint.activate([
      currencyTextField.topAnchor.constraint(equalTo: currencyContainerView.topAnchor, constant: 7),
      currencyTextField.trailingAnchor.constraint(equalTo: currencyContainerView.trailingAnchor, constant: -7),
      currencyTextField.bottomAnchor.constraint(equalTo: currencyContainerView.bottomAnchor, constant: -7)
    ])

    NSLayoutConstraint.activate([
      currencyCustomImage.centerYAnchor.constraint(equalTo: currencyContainerView.centerYAnchor),
      currencyCustomImage.leadingAnchor.constraint(equalTo: currencyContainerView.leadingAnchor, constant: 15),
      currencyCustomImage.widthAnchor.constraint(equalToConstant: 25),
      currencyCustomImage.heightAnchor.constraint(equalToConstant: 25)
    ])

    currencyTextField.leadingAnchor.constraint(equalTo: currencyCustomImage.trailingAnchor, constant: 15).isActive = true
  }


  func configureSignUpButton() {

    signUpButton.addTarget(self, action: #selector(callSignUpButton), for: .touchUpInside)

    signUpButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      signUpButton.topAnchor.constraint(equalTo: currencyContainerView.bottomAnchor, constant: 30),
      signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      signUpButton.heightAnchor.constraint(equalToConstant: 45)
    ])

  }


  func configureGoBackButton() {

    goBackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)

    goBackButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      goBackButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30),
      goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      goBackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      goBackButton.heightAnchor.constraint(equalToConstant: 45)
    ])
  }
}
