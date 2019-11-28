import Foundation
import Objectia

extension String: Error {}

do {
    guard let apiKey = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] else {
        throw "API key not set"
    }
    try ObjectiaClient.initialize(apiKey: apiKey) 
    let location = try GeoLocation.get(ip: "1.1.1.1")
    print("Country code:", location!.countryCode!)
} catch let err as ObjectiaError {
    print("API request failed:") 
    switch err {
        case .badRequest(let params):
            print("* Status:", 400) 
            print("* Code:", params.code) 
            print("* Message:", params.reason) 
        default:
            print(err) 
    }
} catch {
    print("Error:", error) 
}
