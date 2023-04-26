//
//  Transaction.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

struct Transaction: Codable {
  let senderPhoneNumber: String
  let receiverPhoneNumber: String
  let sendingAccountId: Int
  let receivingAccountId: Int
  let transactionTime: Int
  let amount: Double
  let comment: String
}

enum SortingOrder {
  case newestToOldest
  case oldestToNewest
  case smallestToBiggest
  case biggestToSmallest
}


enum TransactionDirection {
  case outgoing
  case incoming
}
