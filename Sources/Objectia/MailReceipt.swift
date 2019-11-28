//
//  MailReceipt.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

public struct MailReceipt : Decodable {
    public var id: String
    public var acceptedRecipients: Int
    public var rejectedRecipients: Int

    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case acceptedRecipients = "accepted_recipients"
        case rejectedRecipients = "rejected_recipients"
    }
}

