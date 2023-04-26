//
//  BNAvatarImageView.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import UIKit

class BNAvatarImageView: UIImageView {
  
  let placeholderImage = Images.placeholder
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    layer.cornerRadius = bounds.width / 2
    clipsToBounds = true
    image = placeholderImage
    translatesAutoresizingMaskIntoConstraints = false
  }
  
}

