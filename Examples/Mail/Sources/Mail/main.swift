import Foundation
import Objectia

extension String: Error {}

do {
    guard let apiKey = ProcessInfo.processInfo.environment["OBJECTIA_APIKEY"] else {
        throw "API key not set"
    }
    try ObjectiaClient.initialize(apiKey: apiKey) 
    var message = MailMessage(from: "me@example.com", to: ["you@example.com"], subject: "Test", text: "This is just a test")
    message.attachments = ["/Me/pictures/photo.jpg"]
    let receipt = try Mail.send(message: message)
    print("Accepted recipients:", receipt!.acceptedRecipients)
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
