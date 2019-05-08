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
            print("Requests:", usage!.geoLocationRequests!)
            print("Requests:", usage!.currencyRequests!)

        } catch {
            print("Unexpected error: \(error).")
        }


        //let res = obj.Test()
        //XCTAssertEqual(res, "HEI")   
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