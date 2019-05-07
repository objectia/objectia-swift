import Foundation

class RestClient : NSObject, URLSessionDataDelegate {
    var apiKey: String
    var timeout: TimeInterval
    var apiBaseURL: String

    init(apiKey: String, timeout: TimeInterval) {
        self.apiBaseURL = Constants.API_BASE_URL
        self.apiKey = apiKey
        self.timeout = timeout 
    }

    public func get(path: String) -> NSDictionary? {
        var result: NSDictionary?
        execute(method: "GET", path: path)  { 
            (data, error) in
            result = data!
            
        } 
        return result!
    }

    func execute(method: String, path: String, taskCallback: @escaping (NSDictionary?, Error?) -> Void) {
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
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )

        // Excute HTTP Request
        session.dataTask(with: request) {
          (data, response, error) -> Void in
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
                
                taskCallback(convertedJsonIntoDict, nil)

                // Get value by key
                //let firstNameValue = convertedJsonIntoDict["userName"] as? String
                //print(firstNameValue!)
            } catch {
                print("Failed to convert data to JSON")
            }

            self.sema.signal()

        }.resume()
        sema.wait()
    }

    // Used by the execute func
    var sema = DispatchSemaphore( value: 0 )
    /*func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        print("got data \(String(data: data, encoding: .utf8 ) ?? "<empty>")");
        sema.signal()
    }*/
}
