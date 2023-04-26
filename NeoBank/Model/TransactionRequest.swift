//
//  TransactionRequest.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

struct TransactionRequest: Codable {
  let senderPhoneNumber: String
  let token: String
  let receiverPhoneNumber: String
  let senderAccountId: Int
  let amount: Double
  let comment: String
}
