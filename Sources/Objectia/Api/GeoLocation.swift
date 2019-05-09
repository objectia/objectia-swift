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
    //TODO: add all properties...

    static func fromJSON(json: Any?) -> Any? {
        if json is NSDictionary {
            let dict = json as! NSDictionary  
            var result = GeoLocation()
            result.country = dict["country_name"] as? String
            result.countryCode = dict["country_code"] as? String
            return result
        } else if json is NSArray {
            let arr = json as! NSArray
            var result = [GeoLocation]()
            for entry in arr {
                let item = GeoLocation.fromJSON(json: entry) as? GeoLocation
                result.append(item!)
            }
            return result
        }
        return nil
    }

    static func get(ip: String) throws -> GeoLocation? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/geoip/" + ip)
        return GeoLocation.fromJSON(json: data!) as? GeoLocation
    }

    static func getCurrent() throws -> GeoLocation? {
        return try GeoLocation.get(ip: "myip")
    }

    static func getBulk(ipList: [String]) throws -> [GeoLocation]? {
        let restClient = try ObjectiaClient.getRestClient()
        let ips = ipList.joined(separator: ",")
        let data = try restClient.get(path: "/geoip/" + ips)
        return GeoLocation.fromJSON(json: data!) as? [GeoLocation]
    }
 
}