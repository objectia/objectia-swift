//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

public struct Usage {
    var geoLocationRequests: Int?

    static func get() throws -> Usage? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/usage")
        return Usage.fromJSON(json: data!) as? Usage
    }

    static func fromJSON(json: Any?) -> Any? {
        if json is Dictionary<String,Any> {
            let dict = json as! Dictionary<String,Any>  
            var result = Usage()
            result.geoLocationRequests = dict["geoip_requests"] as? Int ?? 0
            return result
        } 
        return nil
    }
}