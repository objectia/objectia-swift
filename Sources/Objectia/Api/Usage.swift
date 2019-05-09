//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

public struct Usage {
    var geoLocationRequests: Int?

    init(from: NSDictionary?) {
        geoLocationRequests = from!["geoip_requests"] as? Int ?? 0
    }

    static func get() throws -> Usage? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/usage")
        return Usage(from: data!)
    }
}