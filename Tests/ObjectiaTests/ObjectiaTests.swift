import XCTest

@testable import Objectia
import Foundation

class ObjectiaTests: XCTestCase {

    var apiKey: String?

    override func setUp() {
        super.setUp()
        if let value = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] {
            self.apiKey = value
        }
    }

    override func tearDown() {
        // put code here..
        super.tearDown()
    }

    func testGetUsage() {
        do {
            try ObjectiaClient.initialize(apiKey: self.apiKey!) 
            let usage = try Usage.get()
            XCTAssertNotNil(usage!)
            print("Requests:", usage!.geoLocationRequests!)
        } catch let err as ObjectiaError {
            print("Request failed", err) 
        } catch {
            XCTAssert(false)      
        }
    }

    func testGetLocation() {
        do {
            try ObjectiaClient.initialize(apiKey: self.apiKey!) 
            let location = try GeoLocation.get(ip: "8.8.8.8")

            XCTAssertNotNil(location!)
            XCTAssertEqual(location!.countryCode!, "US")   
            print("Country:", location!.country!)
            print("Country code:", location!.countryCode!)

            print(location!)
        } catch {
            XCTAssert(false)      
        }
    }

    func testGetLocationWithInvalidIP() {
        do {
            try ObjectiaClient.initialize(apiKey: self.apiKey!) 
            let location = try GeoLocation.get(ip: "288.8.8.8")
            XCTAssertNil(location!)   
         } catch let err as ObjectiaError {
             switch err {
                 case .badRequest(let params):
                    XCTAssertEqual(params.code, "err-invalid-ip")      
                default:
                    XCTAssert(false)      
             }
        } catch {
            XCTAssert(false)      
        }
    }

    func testGetBulkLocation() {
        do {
            try ObjectiaClient.initialize(apiKey: self.apiKey!) 
            let locations = try GeoLocation.getBulk(ipList: ["8.8.8.8", "apple.com"])
            XCTAssertEqual(locations!.count, 2)   

        } catch {
            print("Unexpected error: \(error).")
        }
    }

    /*func testExample() {
        guard let apiKey = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] else {
            print("ERROR")
            return
        }

        do {
            try ObjectiaClient.initialize(apiKey: apiKey) 
            let usage = try Usage.get()
            let requests = usage!["geoip_requests"] as? Int
            print("Requests:", requests!)

        } catch {
            print("error....")
        }
    }*/

}