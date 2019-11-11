//
//  Mail.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

struct Mail {
    static func send(message: MailMessage) throws -> MailReceipt? {
        let restClient = try ObjectiaClient.getRestClient()

        let encoder = JSONEncoder()
        let payload = try encoder.encode(message)

        let data = try restClient.post(path: "/v1/mail/send", payload: payload)
        let resp = try JSONDecoder().decode(Response<MailReceipt>.self, from: data!)
        return resp.data
    }
}