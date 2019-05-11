//
//  GeoLocation.swift
//  Swift client for Objectia API
//
//  Copyright © 2019 UAB Salesfly. All rights reserved.
//
import Foundation

struct GeoLocation : Decodable {
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
        //case currencies
        //case languages
        //case timezone
        //case security 
    }

    static func get(ip: String, fields: String? = nil, hostname: Bool = false, security: Bool = false) throws -> GeoLocation? {
        let restClient = try ObjectiaClient.getRestClient()
        let query = makeQuery(fields: fields, hostname: hostname, security: security)
        let data = try restClient.get(path: "/geoip/" + ip + query)
        let resp = try JSONDecoder().decode(Response<GeoLocation>.self, from: data!)
        dump(resp)
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
        dump(resp)
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
 
    /*static func fromJSON(json: Any?) -> Any? {
        if json is Dictionary<String,Any> {
            let dict = json as! Dictionary<String,Any>  
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
        } else if json is Array<Any> {
            let arr = json as! Array<Any>
            var result = [GeoLocation]()
            for entry in arr {
                let item = GeoLocation.fromJSON(json: entry) as? GeoLocation
                result.append(item!)
            }
            return result
        }
        return nil
    }*/
}