import Foundation
//import Alamofire

class RestClient {
    var apiKey: String
    var timeout: TimeInterval
    var apiBaseURL: String

    init(apiKey: String, timeout: TimeInterval) {
        self.apiBaseURL = Constants.API_BASE_URL
        self.apiKey = apiKey
        self.timeout = timeout 
    }

    private func processInfo(info: NSDictionary?) {
        print("COMPLETED:")
        print(info!)
    }

    public func get(path: String) -> String {
        //var info: NSDictionary
        execute(method: "GET", path: path, completion: processInfo)
        return "xxx"
    }

    func execute(method: String, path: String, completion: @escaping (NSDictionary?) -> Void) {
        guard let url = URL(string: Constants.API_BASE_URL + path) else {
            print("Error: cannot create URL")
            return
        }
        
        // Creaste URL Request
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        request.httpMethod = method

        // Add headers
        request.addValue("Bearer " + self.apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("UTF-8", forHTTPHeaderField: "Accept-Charset")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Constants.USER_AGENT, forHTTPHeaderField: "User-Agent")

        if ["POST", "PUT", "PATCH"].contains(method) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        // set up the session
        //let config = URLSessionConfiguration.default
        //let session = URLSession(configuration: config)
        let session = URLSession.shared

        // Excute HTTP Request
        let task = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in

             guard error == nil else {
                print("error calling api")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            // Convert JSON to NSDictionary
            do {
                guard let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: responseData, options: []) 
                    as? NSDictionary 
                else {
                    print("error trying to convert data to JSON")
                    return
                }

                // Print out dictionary
                print(convertedJsonIntoDict)
                completion(convertedJsonIntoDict)

                // Get value by key
                //let firstNameValue = convertedJsonIntoDict["userName"] as? String
                //print(firstNameValue!)
            } catch {
                print("Failed to convert data to JSON")
            }
        })
        
        task.resume()
    }
}
