//
//  Errors.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

enum ObjectiaError: Error {
  case missingArgument(reason: String)
  case notInitialized(reason: String)
}
