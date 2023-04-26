//
//  NBBodyTitle.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class NBBodyLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  convenience init(text: String, textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.text = text
    self.textAlignment = textAlignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
  }


  private func configure() {
    textColor = .black
    font = UIFont.preferredFont(forTextStyle: .body)
    adjustsFontForContentSizeCategory = true
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.75
    lineBreakMode = .byWordWrapping
    translatesAutoresizingMaskIntoConstraints = false
  }
}
