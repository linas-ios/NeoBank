//
//  AddMoney.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

struct AddMoneyResponse: Codable {
  let id: Int
  let currency: String
  let balance: Double
  let ownerPhoneNumber: String
}

struct AddMoneyRequest: Codable {
  let accountId: Int
  let amountToAdd: Double
}
