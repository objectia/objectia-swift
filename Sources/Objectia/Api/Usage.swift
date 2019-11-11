//
//  Usage.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

struct Usage {
    static func get() throws -> APIUsage? {
        let restClient = try ObjectiaClient.getRestClient()
        let data = try restClient.get(path: "/v1/usage")
        let resp = try JSONDecoder().decode(Response<APIUsage>.self, from: data!)
        return resp.data
    }
}