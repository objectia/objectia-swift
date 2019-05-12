//
//  ServerError.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

struct ServerError {
    static func compose(statusCode: Int) -> Error {
        switch statusCode {
            case 502:
                return ObjectiaError.badGateway(reason: "Bad gateway", code: "err-bad-gateway")
            case 503:
                return ObjectiaError.serviceUnavailable(reason: "Service unavailable", code: "err-service-unavailable")
            default:
                return ObjectiaError.serverError(reason: "Internal server error", code: "err-server-error")
        }
    }
}
