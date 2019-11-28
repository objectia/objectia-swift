//
//  Constants.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

public struct Constants {
    public static let API_BASE_URL: String = "https://api.objectia.com"
    public static let VERSION: String = "0.9.2"
    public static let USER_AGENT: String = "objectia-swift/" + VERSION
    public static let DEFAULT_TIMEOUT: TimeInterval = 30.0 // seconds
}
