//
//  IPTimezone.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

public struct IPTimezone {
    var id: String?
    var localTime: Date?   
    var gmtOffset: Int?          
    var code: String?        
    var daylightSaving: Bool? 

    static func fromJSON(json: Any?) -> Any? {
        if json is Dictionary<String,Any> {
            let dict = json as! Dictionary<String,Any>
            var result = IPTimezone()
            result.id = dict["id"] as? String 
            result.gmtOffset = dict["gmt_offset"] as? Int 
            result.code = dict["code"] as? String 
            result.daylightSaving = dict["daylight_saving"] as? Bool 

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: result.gmtOffset!)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            let ds = dict["localtime"] as? String
            result.localTime = dateFormatter.date(from: ds!)

print("TZ:", dateFormatter.timeZone.identifier)
    print("ORIG.TIME:", ds!)
    print("LOCALTIME:", result.localTime!)
    print("TZ ID:", result.id!)


    //print(TimeZone.knownTimeZoneIdentifiers)

            return result
        }
        return nil
    }
}
