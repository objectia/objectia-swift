//
//  Response.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

struct Response<T: Decodable> : Decodable {
    var status: Int
    var success: Bool
    var message: String?
    var code: String?
    var data: T?
}
