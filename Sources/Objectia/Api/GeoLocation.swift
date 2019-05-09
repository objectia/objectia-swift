//
//  GeoLocation.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

public struct GeoLocation {
    var country: String?
    var countryCode: String?

    init(from: NSDictionary?) {
        country = from!["country_name"] as? String
        countryCode = from!["country_code"] as? String
    }

    static func get(ip: String) throws -> GeoLocation? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/geoip/" + ip)
        return GeoLocation(from: data!)
/*        do {
            let restClient = try ObjectiaClient.getRestClient()
            let data = try restClient.get(path: "/geoip/" + ip)
            return GeoLocation(from: data!)
        } catch {
            print("THROWING...")
            throw error
        }*/
    }

    static func getCurrent() throws -> GeoLocation? {
        return try GeoLocation.get(ip: "myip")
    }

    static func getBulk(ipList: [String]) throws -> [GeoLocation]? {
        let restClient = try ObjectiaClient.getRestClient()
        let ips = ipList.joined(separator: ",")
        let data = try restClient.get(path: "/geoip/" + ips)

        dump(data)

        return nil // GeoLocation(from: data!)
    }
 
}