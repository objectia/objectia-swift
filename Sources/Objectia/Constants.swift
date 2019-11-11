//
//  Constants.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

struct Constants {
     static let API_BASE_URL: String = "https://api.objectia.com"
     static let VERSION: String = "0.9.2"
     static let USER_AGENT: String = "objectia-swift/" + VERSION
     static let DEFAULT_TIMEOUT: TimeInterval = 30.0 // seconds
 }
