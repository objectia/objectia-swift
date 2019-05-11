import Foundation

class RestClient : NSObject, URLSessionDataDelegate {
    var apiKey: String
    var timeout: TimeInterval
    var apiBaseURL: String

    // Used by execute() to wait for request done
    var sema = DispatchSemaphore(value: 0)

    init(apiKey: String, timeout: TimeInterval) {
        self.apiBaseURL = Constants.API_BASE_URL
        self.apiKey = apiKey
        self.timeout = timeout 
    }

    public func get(path: String) throws -> Any? {
        return try request(method: "GET", path: path)
    }

    public func post(path: String, payload: Data?) throws -> Any? {
        return try request(method: "POST", path: path, payload: payload)
    }

    public func put(path: String, payload: Data?) throws -> Any? {
        return try request(method: "PUT", path: path, payload: payload)
    }

    public func patch(path: String, payload: Data?) throws -> Any? {
        return try request(method: "PATCH", path: path, payload: payload)
    }

    public func delete(path: String) throws -> Any? {
        return try request(method: "DELETE", path: path)
    }

    func request(method: String, path: String, payload: Data? = nil) throws -> Any? {
        var result: Any?
        var err: Error?
        try execute(method: method, path: path, payload: payload) { 
            (data, error) in
            result = data
            err = error
        } 
        if result == nil {
            throw err!
        }            
        //print(result!)
        return result!
    }

    func execute(method: String, path: String, payload: Data? = nil, taskCallback: @escaping (Any?, Error?) -> Void) throws {
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
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)

        // Excute HTTP Request
        session.dataTask(with: request) {
          (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    // make sure we got any data
                    if let responseData = data {
                        // Process error without any messages/codes
                        if httpResponse.statusCode >= 500 {
                            switch httpResponse.statusCode {
                                case 502:
                                    taskCallback(nil, ObjectiaError.badGateway(reason: "Bad gateway", code: "err-bad-gateway"))
                                case 503:
                                    taskCallback(nil, ObjectiaError.serviceUnavailable(reason: "Service unavailable", code: "err-service-unavailable"))
                                default:
                                    taskCallback(nil, ObjectiaError.serverError(reason: "Internal server error", code: "err-server-error"))
                            }
                        } else {
                            do {
                                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String,Any>
                                if [200, 201].contains(httpResponse.statusCode) {
                                    taskCallback(json!["data"], nil)
                                } else {
                                    var error: Error
                                    let message = json!["message"] as! String 
                                    let code = json!["code"] as! String
                                    switch (httpResponse.statusCode) {
                                        case 401:
                                            error = ObjectiaError.unauthorized(reason: message, code: code)
                                        case 403:
                                            error = ObjectiaError.forbidden(reason: message, code: code)
                                        case 404:
                                            error = ObjectiaError.notFound(reason: message, code: code)
                                        case 429:
                                            error = ObjectiaError.tooManyRequests(reason: message, code: code)
                                        default:    
                                            error = ObjectiaError.badRequest(reason: message, code: code)
                                    }
                                    taskCallback(nil, error)
                                }
                            } catch {
                                print("Failed to convert data to JSON")
                                taskCallback(nil, error)
                            }
                        }
                    }
                } else {
                    print("Error: did not receive data")
                    taskCallback(nil, error)
                }
            } else {
                print("Error calling api")
                taskCallback(nil, error)
            }
            self.sema.signal()  
        }.resume()
        sema.wait()
    }
}
