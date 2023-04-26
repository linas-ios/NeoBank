//
//  LoginRegisterView.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class ContainerView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = UIColor.white
    layer.cornerRadius = 10
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = .zero
    layer.shadowRadius = 8
  }
}
