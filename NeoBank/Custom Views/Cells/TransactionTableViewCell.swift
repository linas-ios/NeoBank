//
//  TransactionTableViewCell.swift
//  NeoBank
//
//  Created by Linas Nutautas on 23/04/2023.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
  let circleImageView = UIImageView()
  let receiverNumberLabel = UILabel()
  let commentLabel = UILabel()
  let dateLabel = UILabel()
  let amountLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {

    circleImageView.translatesAutoresizingMaskIntoConstraints = false
    receiverNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    commentLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    amountLabel.translatesAutoresizingMaskIntoConstraints = false

    commentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    contentView.addSubview(circleImageView)
    contentView.addSubview(receiverNumberLabel)
    contentView.addSubview(commentLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(amountLabel)

    NSLayoutConstraint.activate([

      circleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      circleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      circleImageView.widthAnchor.constraint(equalToConstant: 85),
      circleImageView.heightAnchor.constraint(equalToConstant: 80),

      receiverNumberLabel.topAnchor.constraint(equalTo: circleImageView.topAnchor),
      receiverNumberLabel.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 15),

      dateLabel.leadingAnchor.constraint(equalTo: receiverNumberLabel.leadingAnchor),
      dateLabel.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor),
      dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -15),

      commentLabel.leadingAnchor.constraint(equalTo: receiverNumberLabel.leadingAnchor),
      commentLabel.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor),
      commentLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -15),

      amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])

    circleImageView.layer.cornerRadius = 40
    circleImageView.clipsToBounds = true
    circleImageView.contentMode = .scaleAspectFit
  }
}

