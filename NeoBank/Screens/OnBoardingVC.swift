//
//  ViewController.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit


class OnBoardingVC: UIViewController {
  
  let logoImageView = UIImageView()
  let bankImageView = UIImageView()
  let titleLabel = NBTitleLabel(text: "Welcome to NeoBank", textAlignment: .center, fontSize: 25)
  let loginButton = NBMainButton(title: "Login")
  let bodyTitle = NBSecondTitleLabel(text: "Don't have an account?", textAlignment: .center, fontSize: 14)
  let signUp = NBMainButton(title: "Sign Up")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLoginVC()
    configureLogoImage()
    configureBankImage()
    configureTitle()
    configureLoginButton()
    configureBodyTitle()
    configureSignUpButton()
  }
  
  
  func configureLoginVC() {
    view.backgroundColor = .white
    view.addSubviews(logoImageView, bankImageView, titleLabel, loginButton, bodyTitle, signUp)
  }
  
  
  func configureLogoImage() {
    
    logoImageView.image = Images.logo
    logoImageView.contentMode = .scaleAspectFit
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.widthAnchor.constraint(equalToConstant: 250),
      logoImageView.heightAnchor.constraint(equalToConstant: 90)
    ])
  }


  func configureBankImage() {
    
    bankImageView.image = Images.bank
    bankImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      bankImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 1),
      bankImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      bankImageView.heightAnchor.constraint(equalToConstant: 300),
      bankImageView.widthAnchor.constraint(equalToConstant: 300)
    ])
  }
  
  
  func configureTitle() {
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: bankImageView.bottomAnchor, constant: 1),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      titleLabel.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
  
  func configureLoginButton() {
    
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
      loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 45),
      loginButton.widthAnchor.constraint(equalToConstant: 280)
    ])
  }
  
  
  @objc func loginButtonTapped() {
    let loginVC = LoginVC()
    navigationController?.pushViewController(loginVC, animated: true)
  }
  
  
  func configureBodyTitle() {
    
    bodyTitle.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      bodyTitle.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
      bodyTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
      bodyTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      bodyTitle.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
  
  func configureSignUpButton() {
    
    signUp.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    signUp.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      signUp.topAnchor.constraint(equalTo: bodyTitle.bottomAnchor, constant: 10),
      signUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      signUp.heightAnchor.constraint(equalToConstant: 45),
      signUp.widthAnchor.constraint(equalToConstant: 280)
    ])
  }
  
  
  @objc func signUpButtonTapped() {
    let signUpVC = RegisterVC()
    navigationController?.pushViewController(signUpVC, animated: true)
  }
}

