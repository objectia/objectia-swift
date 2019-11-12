import XCTest

@testable import Objectia
import Foundation

class ObjectiaTests: XCTestCase {
    override func setUp() {
        super.setUp()
        if let apiKey = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] {
            do {
                try ObjectiaClient.initialize(apiKey: apiKey) 
            } catch {
                print(error)
                XCTAssert(false)      
            }
        }
    }

    override func tearDown() {
        // put code here..
        super.tearDown()
    }

    func testGetUsage() {
        do {
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
            var message = MailMessage(from: "ok@demo2.org", to: ["ok@demo2.org"], subject: "Swift test", text: "This is just a test")
            message.attachments = ["/Users/otto/me.png"]
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

    func testSendMailHTML() {
        do {
            var message = MailMessage(from: "ok@demo2.org", to: ["ok@demo2.org"], subject: "Swift test", text: "This is just a test")
            message.html = "<p>This is the test</p>"
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