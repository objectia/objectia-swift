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
            print("Requests:", usage!.geoLocationRequests)
        } catch let err as ObjectiaError {
            print("Request failed:", err) 
            XCTAssert(false)      
        } catch {
            print(error)
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
            dump(location!)
        } catch {
            print(error)
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
                    print(err)
                    XCTAssert(false)      
             }
        } catch {
            print(error)
            XCTAssert(false)      
        }
    }

    func testGetBulkLocation() {
        do {
            try ObjectiaClient.initialize(apiKey: self.apiKey!) 
            let locations = try GeoLocation.getBulk(ipList: ["8.8.8.8", "apple.com"])
            XCTAssertEqual(locations!.count, 2)   
            dump(locations!)
        } catch {
            print("Unexpected error: \(error).")
            XCTAssert(false)      
        }
    }

    func testSendMail() {
        do {
            try ObjectiaClient.initialize(apiKey: self.apiKey!) 

            let message = MailMessage(from: "ok@demo2.org", to: ["ok@demo2.org"], subject: "Swift test", text: "This is just a test")
            let receipt = try Mail.send(message: message)
            XCTAssertNotNil(receipt!)
            print("Accepted recipients:", receipt!.acceptedRecipients)
        } catch let err as ObjectiaError {
            print("Request failed:", err) 
            XCTAssert(false)      
        } catch {
            print(error)
            XCTAssert(false)      
        }
    }
}