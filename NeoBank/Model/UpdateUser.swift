//
//  UpdateUser.swift
//  NeoBank
//
//  Created by Linas Nutautas on 23/04/2023.
//

import Foundation

struct UpdateUserRequest: Codable {
  let currentPhoneNumber: String
  let newPhoneNumber: String
  let newPassword: String
  let token: String
}

struct UpdateUserResponse: Codable {
  let userId: Int
  let validUntil: Int
  let accessToken: String
  let accountInfo: AccountInfo
}
