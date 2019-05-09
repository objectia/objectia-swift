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
        return try request(method: "GET", path: path)
        /*var result: NSDictionary?
        var err: Error?
        try execute(method: "GET", path: path) { 
            (data, error) in
            result = data
            err = error
        } 
        if result == nil {
            throw err!
        }            
        return result!*/
    }

    public func post(path: String, payload: Data?) throws -> NSDictionary? {
        return try request(method: "POST", path: path, payload: payload)
    }

    func request(method: String, path: String, payload: Data? = nil) throws -> NSDictionary? {
        var result: NSDictionary?
        var err: Error?
        try execute(method: method, path: path, payload: payload) { 
            (data, error) in
            result = data
            err = error
        } 
        if result == nil {
            throw err!
        }            
        return result!
    }

    func execute(method: String, path: String, payload: Data? = nil, taskCallback: @escaping (NSDictionary?, Error?) -> Void) throws {
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
            request.httpBody = payload
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
                        taskCallback(nil, error)
                        self.sema.signal()  
                        return
                    }
                    
                    if [200,201].contains(httpResponse.statusCode) {
                        taskCallback(content["data"] as? NSDictionary, nil)
                    } else {
                        let message = content["message"] as? String
                        let code = content["code"] as? String
                        taskCallback(nil, ObjectiaError.responseError(reason: message!, code: code!, status: httpResponse.statusCode))
                    }
                } catch {
                    print("Failed to convert data to JSON")
                    taskCallback(nil, error)
                }
            }

            self.sema.signal()  
        }.resume()
        sema.wait()
    }

}
