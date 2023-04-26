//
//  NBTextField.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class NBMainTextField: UITextField {

  init(keyboardType: UIKeyboardType) {
    super.init(frame: .zero)
    self.keyboardType = keyboardType
    configure()
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  private func configure() {

    translatesAutoresizingMaskIntoConstraints = false

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

  }

}
