//
//  GeoLocation.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

struct GeoLocation {

    static func get(ip: String, fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> IPLocation? {
        let restClient = try ObjectiaClient.getRestClient()
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/v1/geoip/" + ip + query)
        let resp = try JSONDecoder().decode(Response<IPLocation>.self, from: data!)
        return resp.data
    }

    static func getCurrent(fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> IPLocation? {
        return try GeoLocation.get(ip: "myip", fields: fields, hostname: hostname, security: security)
    }

    static func getBulk(ipList: [String], fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> [IPLocation]? {
        let restClient = try ObjectiaClient.getRestClient()
        let ips = ipList.joined(separator: ",")
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/v1/geoip/" + ips + query)
        let resp = try JSONDecoder().decode(Response<[IPLocation]>.self, from: data!)
        return resp.data
    }

    static private func makeQuery(fields: String? = nil, hostname: Bool = false, security: Bool = false) -> String {
        var result: String = ""
        if (fields != nil) {
            result += "?fields=" + fields!
        }
        if (hostname) {
            result += result.count == 0 ? "?" : "&"
            result += "hostname=true"
        }
        if (security) {
            result += result.count == 0 ? "?" : "&"
            result += "security=true"
        }
        return result
    }
}