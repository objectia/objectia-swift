//
//  ObjectiaClient.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

class ObjectiaClient {
    static var apiKey: String?
    static var timeout: TimeInterval?
    static var restClient: RestClient?

    // Prevent class instantiation
    fileprivate init() {}

    /**
     Initializes the Objectia API client.
     - parameters:
        - apiKey: The API key.
        - timeout: The connection timeout in seconds.
     - throws:
        - `ObjectiaError.missingArgument` if no API is provided.
        - `ObjectiaError.notInitialized` if rest client is used before initialized.
    */
    public static func initialize(apiKey: String, timeout: TimeInterval = Constants.DEFAULT_TIMEOUT) throws {
        try ObjectiaClient.setApiKey(apiKey: apiKey)
        ObjectiaClient.setTimeout(timeout: timeout)
    }

    public static func setApiKey(apiKey: String) throws {
        if apiKey.isEmpty {
           throw ObjectiaError.missingArgument(reason: "No API key provided")
        }
        if apiKey != ObjectiaClient.apiKey {
            ObjectiaClient.invalidate()
        }
        ObjectiaClient.apiKey = apiKey
    }

    public static func setTimeout(timeout: TimeInterval) {
        if timeout != ObjectiaClient.timeout {
            ObjectiaClient.invalidate()
        }
        ObjectiaClient.timeout = timeout
    }

    public static func getRestClient() throws -> RestClient {
        if ObjectiaClient.restClient != nil {
            return ObjectiaClient.restClient!
        }
        if ObjectiaClient.apiKey == nil {
           throw ObjectiaError.notInitialized(reason: "Client was used before ApiKey was set, please call ObjectiaClient.initialize() first")
        }
        ObjectiaClient.restClient = RestClient(apiKey: ObjectiaClient.apiKey!, timeout: ObjectiaClient.timeout!)
        return ObjectiaClient.restClient!
    }

    public static func setRestClient(restClient: RestClient) {
        ObjectiaClient.restClient = restClient
    }

    public static func invalidate() {
        ObjectiaClient.restClient = nil
    }

    public static func getVersion() -> String {
        return Constants.VERSION
    }
}