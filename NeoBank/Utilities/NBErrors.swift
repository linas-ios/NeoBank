//
//  NBErrors.swift
//  NeoBank
//
//  Created by Linas Nutautas on 22/04/2023.
//

import Foundation

enum NBError: String, Error {
  case invalidURL = "The provided URL is invalid. Please check the URL and try again."
  case unableToComplete = "Unable to complete your request. Please check your internet connection."
  case invalidResponse = "Invalid response from the server. Please try again."
  case invalidData = "The data received from the server was invalid. Please try again."
}

enum TransanctionAPIError: String, Error {
  case invalidURL = "The provided URL is invalid"
  case badRequest = "The request is incorrect"
  case unauthorized = "The token is invalid"
  case conflict = "The receiver does not have an account with the provided currency ot there's not enough money in senders account"
  case unknown = "Default"
}
