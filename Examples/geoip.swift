import Foundation
import Objectia

guard let apiKey = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] else {
    print("API key not found...")
    return
}

do {
    try ObjectiaClient.initialize(apiKey: apiKey) 
    let location = try GeoLocation.get(ip: "8.8.8.8")
    print("Country code:", location!.countryCode!)
} catch let err as ObjectiaError {
    print("API request failed:") 
    switch err {
        case .badRequest(let params):
            print("* Status:", 400) 
            print("* Code:", params.code) 
            print("* Message:", params.message) 
        default:
            print("Other error...") 
    }
} catch {
    print("Other error...") 
}