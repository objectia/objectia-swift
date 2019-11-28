//
//  APIUsage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

public struct APIUsage : Decodable {
    public var geoLocationRequests: Int
    public var mailRequests: Int

    private enum CodingKeys : String, CodingKey {
        case geoLocationRequests = "geoip_requests"
        case mailRequests = "mail_requests"
    }
}