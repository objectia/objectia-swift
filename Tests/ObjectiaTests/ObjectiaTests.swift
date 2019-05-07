import XCTest

@testable import Objectia

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

            let data = usage!["data"] as? NSDictionary
            //print(data!)

            let requests = data!["geoip_requests"] as? Int
            print("Requests:", requests!)

        } catch {
            print("error....")
        }


        //let res = obj.Test()
        //XCTAssertEqual(res, "HEI")   
    }
}