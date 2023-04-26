//
//  AuthenticationManager.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

class AuthenticationManager {
  static let shared = AuthenticationManager()
  
  private init() {}
  
  func saveToken(accessToken: String, validUntil: Int) {
    let defaults = UserDefaults.standard
    defaults.setValue(accessToken, forKey: "accessToken")
    defaults.setValue(validUntil, forKey: "validUntil")
  }
  
  func getToken() -> (accessToken: String?, validUntil: Int?) {
    let defaults = UserDefaults.standard
    let accessToken = defaults.string(forKey: "accessToken")
    let validUntil = defaults.integer(forKey: "validUntil")
    return (accessToken, validUntil)
  }
  
  func isTokenExpired(validUntil: Int) -> Bool {
    let currentTime = Int(Date().timeIntervalSince1970)
    return currentTime >= validUntil
  }
  
  func clearToken() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "accessToken")
    defaults.removeObject(forKey: "validUntil")
  }
}
