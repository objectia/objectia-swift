//
//  ResponseError.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

public struct ResponseError : Decodable {
    static func compose(from data: Data, statusCode: Int) -> Error {
        do {
            let resp = try JSONDecoder().decode(Response<ResponseError>.self, from: data)
            switch (statusCode) {
                case 401:
                    return ObjectiaError.unauthorized(reason: resp.message!, code: resp.code!)
                case 403:
                    return ObjectiaError.forbidden(reason: resp.message!, code: resp.code!)
                case 404:
                    return ObjectiaError.notFound(reason: resp.message!, code: resp.code!)
                case 429:
                    return ObjectiaError.tooManyRequests(reason: resp.message!, code: resp.code!)
                default:    
                    return ObjectiaError.badRequest(reason: resp.message!, code: resp.code!)
            }
        } catch {
            print("Unable to parse error")
            return error
        }
    }
}
