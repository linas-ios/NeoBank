//
//  LoginVC.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class LoginVC: BaseViewController {

  let titleLabel = NBTitleLabel(text: "Log In", textAlignment: .center, fontSize: 30)
  let phoneContainerView = ContainerView()
  let phoneCustomImage = UIImageView()
  let phoneLabel = NBBodyLabel(text: "Your mobile number", textAlignment: .left, fontSize: 12)
  let phoneTextField = NBMainTextField(keyboardType: .numberPad)

  let passwordContainerView = ContainerView()
  let passwordCustomImage = UIImageView()
  let passwordLabel = NBBodyLabel(text: "Your password", textAlignment: .left, fontSize: 12)
  let passwordTextField = NBMainTextField(keyboardType: .default)
  let forgotPasswordLabel = NBBodyLabel(text: "Forget password?", textAlignment: .right, fontSize: 12) //color green

  let loginButton = NBMainButton(title: "Log In")

  let goBackButton = NBMainButton(title: "Back")


  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubviews(titleLabel, phoneContainerView, phoneLabel, phoneTextField, passwordContainerView, passwordLabel, passwordTextField, forgotPasswordLabel, loginButton, goBackButton)

    configureLoginVC()
    configureTitleLabel()
    configurePhoneLabel()
    configurePhoneTextField()
    configurePasswordLabel()
    configurePasswordTextField()
    configureForgotPassword()
    configureLoginButton()
    configureGoBackButton()
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


  @objc func callLoginButton() {

    guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
      Alert.showAlert(title: "Error", message: "Phone number not exist. Please try again", on: self)
      return
    }

    guard let password = passwordTextField.text, !password.isEmpty else {
      Alert.showAlert(title: "Error", message: "Password incorrect. Please try again", on: self)
      return
    }

    Task {
      do {

        let loginResponse = try await NetworkManager.shared.loginRequest(phoneNumber: phoneNumber, password: password)

        print("Logged in successfully: \(loginResponse)")

        DispatchQueue.main.async {
          let tabBarVC = NBTabBarController()

          UserDefaults.standard.set(loginResponse.accessToken, forKey: "accessToken")
          UserDefaults.standard.set(loginResponse.validUntil, forKey: "validUntil")

          if let homeNC = tabBarVC.viewControllers?[0] as? UINavigationController,
             let homeVC = homeNC.viewControllers.first as? HomeVC {
            homeVC.currentBalance = loginResponse.accountInfo.balance
            homeVC.accountId = loginResponse.accountInfo.id
          }

          if let transactionNC = tabBarVC.viewControllers?[1] as? UINavigationController,
             let transactionVC = transactionNC.viewControllers.first as? TransactionVC {
            transactionVC.currentBalance = loginResponse.accountInfo.balance
            transactionVC.accountId = loginResponse.accountInfo.id
            transactionVC.userCurrency = loginResponse.accountInfo.currency
          }

          if let settingsNC = tabBarVC.viewControllers?[2] as? UINavigationController,
             let settingsVC = settingsNC.viewControllers.first as? SettingsVC {
            settingsVC.currentBalance = loginResponse.accountInfo.balance
            settingsVC.accountId = loginResponse.accountInfo.id

            if let userToken = UserDefaults.standard.string(forKey: "accessToken") {
              settingsVC.userToken = userToken
            }
          }


          tabBarVC.modalPresentationStyle = .fullScreen
          self.present(tabBarVC, animated: true)
        }
      } catch {
        Alert.showAlert(title: "Error", message: "Login failed. Please try again", on: self)
      }
    }
  }


  func configureLoginVC() {
    keyboardHeightAdjustment = 0.2
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


  func configureForgotPassword() {

    forgotPasswordLabel.textColor = .green
    forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      forgotPasswordLabel.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 8),
      forgotPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
      forgotPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
    ])
  }



  func configureLoginButton() {

    loginButton.addTarget(self, action: #selector(callLoginButton), for: .touchUpInside)

    loginButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      loginButton.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 20),
      loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      loginButton.heightAnchor.constraint(equalToConstant: 45)
    ])
  }


  func configureGoBackButton() {

    goBackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)

    goBackButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      goBackButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
      goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      goBackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      goBackButton.heightAnchor.constraint(equalToConstant: 45)
    ])
  }
}


