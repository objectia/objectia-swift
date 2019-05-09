//
//  Errors.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

enum APIError : Error {
  case badRequest(reason: String, code: String) // 400
  case unauthorized(reason: String, code: String) // 401
  case forbidden(reason: String, code: String) // 403
  case notFound(reason: String, code: String) //404
  case tooManyRequests(reason: String, code: String) //429
  //---
  case serverError(reason: String, code: String) // 500
  case badGateway(reason: String, code: String) // 502
  case serviceUnavailable(reason: String, code: String) // 503
}


enum ObjectiaError: Error {
  case missingArgument(reason: String)
  case notInitialized(reason: String)
  case invalidURL(reason: String)
  case responseError(reason: String, code: String, status: Int)
  case connectionError(reason: String, code: String, status: Int)
}
