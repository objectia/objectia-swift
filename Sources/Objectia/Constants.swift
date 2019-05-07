//
//  Constants.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

struct Constants {
     static let API_BASE_URL: String = "https://api.objectia.com/rest/v1"
     static let VERSION: String = "0.9.1"
     static let USER_AGENT: String = "objectia-swift/" + VERSION
     static let DEFAULT_TIMEOUT: TimeInterval = 30.0 // seconds
 }
