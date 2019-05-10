//
//  GeoLocation.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation


public struct GeoLocation {
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
    var currencies: [IPCurrency]?
    var languages: [IPLanguage]?
    var flag: String?                    
	var flagEmoji: String?               
    var isEU: Bool? = false;        
	var tld: String?                     
    var timezone: IPTimezone?
    //var IPSecurity security 

    static func fromJSON(json: Any?) -> Any? {
        if json is NSDictionary {
            let dict = json as! NSDictionary  
            var result = GeoLocation()

            result.ipAddress = dict["ip"] as? String
            result.type = dict["type"] as? String
            result.hostname = dict["hostname"] as? String
            result.continent = dict["continent_name"] as? String
            result.continentCode = dict["continent_code"] as? String
            result.country = dict["country_name"] as? String
            result.countryNative = dict["country_name_native"] as? String
            result.countryCode = dict["country_code"] as? String
            result.countryCode3 = dict["country_code3"] as? String
            result.capital = dict["capital"] as? String
            result.region = dict["region_name"] as? String
            result.regionCode = dict["region_code"] as? String
            result.city = dict["city"] as? String
            result.postcode = dict["postcode"] as? String
            result.latitude = dict["latitude"] as? Double
            result.longitude = dict["longitude"] as? Double
            result.phonePrefix = dict["phone_prefix"] as? String
            result.flag = dict["flag"] as? String
            result.flagEmoji = dict["flag_emoji"] as? String
            result.isEU = dict["is_eu"] as? Bool
            result.tld = dict["internet_tld"] as? String

            result.currencies = IPCurrency.fromJSON(json: dict["currencies"]) as? [IPCurrency]
            result.languages = IPLanguage.fromJSON(json: dict["languages"]) as? [IPLanguage]
            result.timezone = IPTimezone.fromJSON(json: dict["timezone"]) as? IPTimezone

            return result
        } else if json is NSArray {
            let arr = json as! NSArray
            var result = [GeoLocation]()
            for entry in arr {
                let item = GeoLocation.fromJSON(json: entry) as? GeoLocation
                result.append(item!)
            }
            return result
        }
        return nil
    }

    static func get(ip: String, fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> GeoLocation? {
        let restClient = try ObjectiaClient.getRestClient()
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/geoip/" + ip + query)
        return GeoLocation.fromJSON(json: data!) as? GeoLocation
    }

    static func getCurrent(fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> GeoLocation? {
        return try GeoLocation.get(ip: "myip", fields: fields, hostname: hostname, security: security)
    }

    static func getBulk(ipList: [String], fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> [GeoLocation]? {
        let restClient = try ObjectiaClient.getRestClient()
        let ips = ipList.joined(separator: ",")
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/geoip/" + ips + query)
        return GeoLocation.fromJSON(json: data!) as? [GeoLocation]
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