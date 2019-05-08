import Foundation

class RestClient : NSObject, URLSessionDataDelegate {
    var apiKey: String
    var timeout: TimeInterval
    var apiBaseURL: String

    // Used by the execute func
    var sema = DispatchSemaphore(value: 0)

    init(apiKey: String, timeout: TimeInterval) {
        self.apiBaseURL = Constants.API_BASE_URL
        self.apiKey = apiKey
        self.timeout = timeout 
    }

    public func get(path: String) throws -> NSDictionary? {
        var result: NSDictionary?
        var err: Error?
        try execute(method: "GET", path: path) { 
            (data, error) in
            result = data
            err = error
        } 
        if result == nil {
            print("THROW 1")
            throw err!
        }            
        return result!
    }

    func execute(method: String, path: String, taskCallback: @escaping (NSDictionary?, Error?) -> Void) throws {
        guard let url = URL(string: Constants.API_BASE_URL + path) else {
            throw ObjectiaError.invalidURL(reason: Constants.API_BASE_URL + path)
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
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )

        // Excute HTTP Request
        session.dataTask(with: request) {
          (data, response, error) -> Void in
             guard error == nil else {
                print("error calling api")
                print(error!)
                taskCallback(nil, error)
                self.sema.signal()  
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("Status code:", httpResponse.statusCode)

                if [200,201].contains(httpResponse.statusCode) {
                    // make sure we got data
                    guard let responseData = data else {
                        print("Error: did not receive data")
                        taskCallback(nil, error)
                        self.sema.signal()  
                        return
                    }

                    // Convert JSON to NSDictionary
                    do {
                        guard let content = try JSONSerialization.jsonObject(with: responseData, options: []) 
                            as? NSDictionary 
                        else {
                            print("error trying to convert data to JSON")
                            return
                        }
                        
                        taskCallback(content["data"] as? NSDictionary, nil)

                        // Get value by key
                        //let firstName = content["userName"] as? String
                        //print(firstName!)
                    } catch {
                        print("Failed to convert data to JSON")
                    }

                    //taskCallback(responseData, nil)
                } else {
                    print("ERROR.....")
                    taskCallback(nil, ObjectiaError.response(reason:"reason", code:"code", status:httpResponse.statusCode))
                }
            }


            // make sure we got data
/*            guard let responseData = data else {
                print("Error: did not receive data")
                taskCallback(nil, error)
                self.sema.signal()  
                return
            }

print(response!)
*/
              /*// Convert JSON to NSDictionary
            do {
                guard let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: responseData, options: []) 
                    as? NSDictionary 
                else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                taskCallback(convertedJsonIntoDict, nil)

                // Get value by key
                //let firstNameValue = convertedJsonIntoDict["userName"] as? String
                //print(firstNameValue!)
            } catch {
                print("Failed to convert data to JSON")
            }*/

            self.sema.signal()  
        }.resume()
        sema.wait()
    }

}
