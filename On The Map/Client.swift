//
//  Client.swift
//  On The Map
//
//  Created by Hayne Park on 11/11/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import Foundation

// MARK: - Client: NSObject

class Client : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared

    // authentication state
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, urlString: String, parameters: [String : AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL and configure the request */
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        if(method == "udacity") {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue(Constants.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
            
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(nil, NSError(domain: "Network Error", code: 1, userInfo: ["error":"error"]))
                    return
                }
                
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(nil, NSError(domain: "Invalid credentials", code: 1, userInfo: ["error":"error"]))
                    return
            }
                
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(nil, NSError(domain: "No data error", code: 1, userInfo: ["error":"error"]))
                return
            }
                
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if(method == "udacity") {
                let dataLength = data.count
                let r = 5...Int(dataLength)
                let newData = data.subdata(in: Range(r)) /* subset response data! */
                Client.parseJSONWithCompletionHandler(data: newData as NSData, completionHandler: completionHandler)
            } else {
                Client.parseJSONWithCompletionHandler(data: data as NSData, completionHandler: completionHandler)
            }
        }
            
        /* 7. Start the request */
            task.resume()
        
            return task
        }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let parsedResult: [String: AnyObject]
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [String: AnyObject]
        } catch {
            return
        }
        
        completionHandler(parsedResult as AnyObject?, nil)
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, urlString: String, jsonBody: [String : AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL and configure the request */
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        if(method == "udacity") {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        } else {
            request.addValue(Constants.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        //print(request.allHTTPHeaderFields)
        //print(NSString(data: request.HTTPBody!, encoding:NSUTF8StringEncoding)!)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(nil, NSError(domain: "Network Error", code: 1, userInfo: ["error":"error"]))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(nil, NSError(domain: "Invalid credentials", code: 1, userInfo: ["error":"error"]))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(nil, NSError(domain: "No data error", code: 1, userInfo: ["error":"error"]))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if(method == "udacity") {
                let dataLength = data.count
                let r = 5...Int(dataLength)
                let newData = data.subdata(in: Range(r)) /* subset response data! */
                Client.parseJSONWithCompletionHandler(data: newData as NSData, completionHandler: completionHandler)
            } else {
                Client.parseJSONWithCompletionHandler(data: data as NSData, completionHandler: completionHandler)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForDeleteMethod(urlString: String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let urlString = urlString
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(nil, NSError(domain: "Network Error", code: 1, userInfo: ["error":"error"]))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(nil, NSError(domain: "Invalid credentials", code: 1, userInfo: ["error":"error"]))
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(nil, NSError(domain: "No data error", code: 1, userInfo: ["error":"error"]))
                return
            }
            
            let dataLength = data.count
            let r = 5...Int(dataLength)
            let newData = data.subdata(in: Range(r))
            Client.parseJSONWithCompletionHandler(data: newData as NSData, completionHandler: completionHandler)
        }
        
        task.resume()
        return task
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}
