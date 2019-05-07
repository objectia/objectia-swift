//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
public struct Usage : Decodable {

    // MARK: - Properties

    /// The geoip requests counter.
    public let geoLocationRequests: Int

    public static func get() throws -> String /*Usage?*/ {
        let restClient = try ObjectiaClient.getRestClient()
        let result = restClient.get(path: "/usage")
        return result
    }

    private enum CodingKeys: String, CodingKey {
        //case id, email, phone
        case geoLocationRequests = "geoip_requests"
    }
}