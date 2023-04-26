//
//  NBSecondTextField.swift
//  NeoBank
//
//  Created by Linas Nutautas on 23/04/2023.
//

import UIKit

class NBSecondTextField : UITextField, UITextFieldDelegate {
  let customColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1.0)

  init(keyboardType: UIKeyboardType, placeholder: String) {
    super.init(frame: .zero)
    self.keyboardType = keyboardType
    self.placeholder = placeholder
    configure()
  }


  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  private func configure() {

    let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
    attributedPlaceholder = NSAttributedString(string: placeholder ?? "" , attributes: attributes)

    translatesAutoresizingMaskIntoConstraints = false

    layer.cornerRadius = 10
    layer.borderWidth = 2
    layer.borderColor = customColor.cgColor


    textColor = .black
    tintColor = .black
    textAlignment = .center
    font = UIFont.preferredFont(forTextStyle: .subheadline)
    adjustsFontSizeToFitWidth = true
    minimumFontSize = 12


    backgroundColor = .clear
    autocorrectionType = .no
    autocapitalizationType = .none
    returnKeyType = .go
    clearButtonMode = .whileEditing

    delegate = self
  }


  func textFieldDidBeginEditing(_ textField: UITextField) {
    layer.borderColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0).cgColor
  }

  
  func textFieldDidEndEditing(_ textField: UITextField) {
    layer.borderColor = customColor.cgColor
  }
}

