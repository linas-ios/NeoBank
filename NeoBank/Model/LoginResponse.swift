//
//  Login.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

struct AccountInfo: Codable {
    let id: Int
    let currency: String
    let balance: Double
    let ownerPhoneNumber: String
}

struct LoginResponse: Codable {
    let userId: Int
    let validUntil: Int
    let accessToken: String
    let accountInfo: AccountInfo
}

struct LoginRequestBody: Codable {
    let phoneNumber: String
    let password: String
}
