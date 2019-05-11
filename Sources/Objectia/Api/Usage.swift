//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

struct Usage : Decodable {
    var geoLocationRequests: Int

    private enum CodingKeys : String, CodingKey {
        case geoLocationRequests = "geoip_requests"
    }

    static func get() throws -> Usage? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/usage")
        let resp = try JSONDecoder().decode(Response<Usage>.self, from: data!)
        dump(resp)
        return resp.data
    }
}