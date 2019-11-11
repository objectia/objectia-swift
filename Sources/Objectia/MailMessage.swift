//
//  MailMessage.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

public struct MailMessage: Codable {
  var from: String
  var to: [String]
  var subject: String
  var text: String

  init(from: String, to: [String], subject: String, text: String) {        
    self.from = from
    self.to = to
    self.subject = subject
    self.text = text
  }
}