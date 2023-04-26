//
//  NBMainButton.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class NBMainButton: UIButton {

  let color = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1.0)

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  convenience init(title: String) {
    self.init(frame: .zero)
    set(title: title)
  }


  private func configure() {
    configuration = .filled()
    configuration?.cornerStyle = .medium
    translatesAutoresizingMaskIntoConstraints = false
  }


  final func set(title: String) {
    configuration?.baseBackgroundColor = color
    configuration?.baseForegroundColor = .white
    configuration?.title = title
  }


}
