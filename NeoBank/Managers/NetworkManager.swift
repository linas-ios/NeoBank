//
//  NetworkManager.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

class NetworkManager {

  private let baseURL = "http://134.122.94.77:7000/api/"
  static let shared = NetworkManager()

  enum UserEndpoint: String {
    case login = "User/login"
    case register = "User/register"
    case addMoney = "Accounts"
    case sendMoney = "Transactions"
    case updateUser = "User"
  }

  func createURL(endpoint: UserEndpoint) -> URL? {
    return URL(string: baseURL + endpoint.rawValue)
  }

  private init() { }

  func loginRequest(phoneNumber: String, password: String) async throws -> LoginResponse {
    let requestBody = LoginRequestBody(phoneNumber: phoneNumber, password: password)

    guard let loginURL = createURL(endpoint: .login) else {
      throw NBError.invalidData
    }

    var request = URLRequest(url: loginURL)

    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(requestBody)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }

    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
    AuthenticationManager.shared.saveToken(accessToken: decodedResponse.accessToken, validUntil: decodedResponse.validUntil)
    return decodedResponse
  }


  func registerRequest(phoneNumber: String, password: String, currency: String) async throws -> RegisterResponse {
    let requestBody = RegisterRequest(phoneNumber: phoneNumber, password: password, currency: currency)

    guard let registerURL = createURL(endpoint: .register) else {
      throw NBError.invalidData
    }

    var request = URLRequest(url: registerURL)

    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(requestBody)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NBError.invalidResponse
    }

    let decodedResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
    return decodedResponse
  }


  func addMoneyRequest(accountId: Int, amountToAdd: Double) async throws -> AddMoneyResponse {
    let requestBody = AddMoneyRequest(accountId: accountId, amountToAdd: amountToAdd)

    guard let addMoneyURL = createURL(endpoint: .addMoney) else {
      throw NBError.invalidURL
    }

    var request = URLRequest(url: addMoneyURL)

    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(requestBody)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NBError.invalidResponse
    }

    let decodedResponse = try JSONDecoder().decode(AddMoneyResponse.self, from: data)
    return decodedResponse

  }


  func sendTransaction(_ transaction: TransactionRequest) async throws -> String {

    guard let sendMoney = createURL(endpoint: .sendMoney) else {
      throw TransanctionAPIError.invalidURL
    }

    var request = URLRequest(url: sendMoney)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
      let jsonData = try JSONEncoder().encode(transaction)
      request.httpBody = jsonData
    } catch {
      throw TransanctionAPIError.badRequest
    }

    let (_, response) = try await URLSession.shared.data(for: request) // didn't use the data variable in the response handling. In this case, since we not processing the response data
    guard let httpResponse = response as? HTTPURLResponse else { throw NBError.invalidResponse }

    switch httpResponse.statusCode {
    case 200:
      return "Transaction Made"
    case 400:
      throw TransanctionAPIError.badRequest
    case 401:
      throw TransanctionAPIError.unauthorized
    case 409:
      throw TransanctionAPIError.conflict
    default:
      throw TransanctionAPIError.unknown
    }
  }


  func fetchTransactions(forUserID userID: Int) async throws -> [Transaction] {

    let baseURL = "http://134.122.94.77:7000/api/Transactions/?accountId=\(userID)"
    guard let url = URL(string: baseURL) else {
      throw NBError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NBError.invalidResponse
    }

    let transactions = try JSONDecoder().decode([Transaction].self, from: data)
    return transactions
  }


  func updateUser(requestBody: UpdateUserRequest) async throws -> UpdateUserResponse {

    guard let updateUser = createURL(endpoint: .updateUser) else {
      throw NBError.invalidURL
    }

    var request = URLRequest(url: updateUser)

    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpBody = try JSONEncoder().encode(requestBody)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NBError.invalidResponse
    }

    let decodedResponse = try JSONDecoder().decode(UpdateUserResponse.self, from: data)
    return decodedResponse
  }






}


