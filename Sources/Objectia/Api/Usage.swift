//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

public struct Usage {
    var geoLocationRequests: Int? = 0
    var currencyRequests: Int? = 0

    init(from: NSDictionary?) {
        geoLocationRequests = from!["geoip_requests"] as? Int ?? 0
        currencyRequests = from!["currency_requests"] as? Int ?? 0
    }

    static func get() throws -> Usage? {
        do {
            let restClient = try ObjectiaClient.getRestClient()
            let data = try restClient.get(path: "/usage")
            return Usage(from: data!)
        } catch {
            print("THROWING...")
            throw error
        }
    }
}