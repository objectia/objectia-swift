//
//  IPCurrency.swift
//  Swift client for Objectia API 
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//

import Foundation

public struct IPCurrency {
    var code: String?
    var numericCode: String?   
    var name: String?          
    var pluralName: String?    
    var symbol: String?        
    var nativeSymbol: String? 
    var decimalDigits: Int?    

    static func fromJSON(json: Any?) -> Any? {
        if json is NSArray {
            let arr = json as! NSArray
            var result = [IPCurrency]()
            for entry in arr {
                let e = entry as? NSDictionary
                var item = IPCurrency()
                item.code = e!["code"] as? String 
                item.numericCode = e!["num_code"] as? String 
                item.name = e!["name"] as? String 
                item.pluralName = e!["name_plural"] as? String 
                item.symbol = e!["symbol"] as? String 
                item.nativeSymbol = e!["symbol_native"] as? String 
                item.decimalDigits = e!["decimal_digits"] as? Int 
                result.append(item)
            }
            return result
        }
        return nil
    }
}
