//
//  Register.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

struct RegisterResponse: Codable {
    let userId: Int
}

struct RegisterRequest: Codable {
    let phoneNumber: String
    let password: String
    let currency: String
}
