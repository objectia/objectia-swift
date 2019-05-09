//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

public struct Usage {
    var geoLocationRequests: Int?

    /*init(from: Any?) {
        if from is NSDictionary {
            let dict = from as! NSDictionary  
            geoLocationRequests = dict["geoip_requests"] as? Int ?? 0
        } else if from is NSArray {

        }
    }*/

    static func fromJSON(json: Any?) -> Any? {
        if json is NSDictionary {
            let dict = json as! NSDictionary  
            var result = Usage()
            result.geoLocationRequests = dict["geoip_requests"] as? Int ?? 0
            return result
        } 
        return nil
    }

    static func get() throws -> Usage? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/usage")
        return Usage.fromJSON(json: data!) as? Usage
    }
}