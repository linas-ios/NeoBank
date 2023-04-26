//
//  NBTitleLabel.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class NBTitleLabel: UILabel {

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
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
  }

  private func configure() {
    textColor = UIColor(red: 94/255.0, green: 94/255.0, blue: 96/255.0, alpha: 1)
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byWordWrapping
    numberOfLines = 2
    translatesAutoresizingMaskIntoConstraints = false
  }



}
