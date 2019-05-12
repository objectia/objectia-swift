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

    public func get(path: String) throws -> Data? {
        return try request(method: "GET", path: path)
    }

    public func post(path: String, payload: Data?) throws -> Data? {
        return try request(method: "POST", path: path, payload: payload)
    }

    public func put(path: String, payload: Data?) throws -> Data? {
        return try request(method: "PUT", path: path, payload: payload)
    }

    public func patch(path: String, payload: Data?) throws -> Data? {
        return try request(method: "PATCH", path: path, payload: payload)
    }

    public func delete(path: String) throws -> Data? {
        return try request(method: "DELETE", path: path)
    }

    func request(method: String, path: String, payload: Data? = nil) throws -> Data? {
        var result: Data?
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

    func execute(method: String, path: String, payload: Data? = nil, taskCallback: @escaping (Data?, Error?) -> Void) throws {
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
                    if let responseData = data {
                        switch httpResponse.statusCode {
                            case 200 ... 299:
                                taskCallback(responseData, nil)
                            case 400 ... 499:
                                let error = ResponseError.compose(from: responseData, statusCode: httpResponse.statusCode)
                                taskCallback(nil, error)
                            case 500 ... 599:    
                                let error = ServerError.compose(statusCode: httpResponse.statusCode)
                                taskCallback(nil, error)
                            default:
                                assert(false)
                                break
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
