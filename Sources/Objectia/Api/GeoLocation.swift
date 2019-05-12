//
//  GeoLocation.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

struct GeoLocation : Decodable {

    struct Currency : Decodable {
        var code: String?
        var numericCode: String?   
        var name: String?          
        var pluralName: String?    
        var symbol: String?        
        var nativeSymbol: String? 
        var decimalDigits: Int?    

        private enum CodingKeys : String, CodingKey {
            case code            
            case numericCode = "num_code"
            case name
            case pluralName = "name_plural"                
            case symbol
            case nativeSymbol = "symbol_native"        
            case decimalDigits = "decimal_digits"        
        }
    }

    struct Language : Decodable {
        var code: String?
        var code2: String?   
        var name: String?          
        var nativeName: String? 
        var rtl: Bool?    

        private enum CodingKeys : String, CodingKey {
            case code            
            case code2 = "code2"
            case name
            case nativeName = "native_name"                
            case rtl
        }
    }

    struct Timezone : Decodable {
        var id: String?
        var localTime: String?   
        var gmtOffset: Int?          
        var code: String?        
        var daylightSaving: Bool? 

        private enum CodingKeys : String, CodingKey {
            case id
            case localTime = "localtime"
            case gmtOffset = "gmt_offset"                
            case code            
            case daylightSaving = "daylight_saving"        
        }
    }

    //FIXME
    struct Security : Decodable {
        var x: String?
        private enum CodingKeys : String, CodingKey {
            case x
        }
    }

    var ipAddress: String?         
    var type: String?   // ipv4 or ipv6       
    var hostname: String?                
	var continent: String?            
	var continentCode: String?        
    var country: String?              
    var countryNative: String?        
    var countryCode: String? 
    var countryCode3: String?         
	var capital: String?              
	var region: String?                  
	var regionCode: String?              
	var city: String?                     
	var postcode: String?                 
	var latitude: Double? = 0.0;              
	var longitude: Double? = 0.0;    
	var phonePrefix: String?             
    var flag: String?                    
	var flagEmoji: String?               
    var isEU: Bool? = false;        
	var tld: String?                     
    var currencies: [Currency]?
    var languages: [Language]?
    var timezone: Timezone?
    var security: Security? 

    private enum CodingKeys : String, CodingKey {
        case ipAddress = "ip"         
        case type
        case hostname                
        case continent            
        case continentCode = "continent_code"        
        case country = "country_name"    
        case countryNative = "country_name_native"        
        case countryCode = "country_code" 
        case countryCode3 = "country_code3"         
        case capital              
        case region = "region_name"                  
        case regionCode = "region_code"              
        case city                     
        case postcode                 
        case latitude
        case longitude
        case phonePrefix = "phone_prefix"             
        case flag                    
        case flagEmoji = "flag_emoji"               
        case isEU = "is_eu"
        case tld = "internet_tld"                     
        case currencies
        case languages
        case timezone
        case security 
    }

    static func get(ip: String, fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> GeoLocation? {
        let restClient = try ObjectiaClient.getRestClient()
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/geoip/" + ip + query)
        let resp = try JSONDecoder().decode(Response<GeoLocation>.self, from: data!)
        return resp.data
    }

    static func getCurrent(fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> GeoLocation? {
        return try GeoLocation.get(ip: "myip", fields: fields, hostname: hostname, security: security)
    }

    static func getBulk(ipList: [String], fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> [GeoLocation]? {
        let restClient = try ObjectiaClient.getRestClient()
        let ips = ipList.joined(separator: ",")
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/geoip/" + ips + query)
        let resp = try JSONDecoder().decode(Response<[GeoLocation]>.self, from: data!)
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