//
//  Convenience.swift
//  On The Map
//
//  Created by Hayne Park on 11/11/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import Foundation

// MARK: - Convenience: NSObject

extension Client {
    
    func authenticateWithViewController(username: String?, password: String?, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        self.postSessionID(username: username, password: password) { (success, errorString) in
            if success {
                completionHandler(success, errorString)
            } else {
                completionHandler(success, errorString)
            }
        }
    }
    
    func postSessionID(username: String?, password: String?, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody = [
            Client.JSONBodyKeys.udacity: [
                Client.JSONBodyKeys.username: "\(username!)",
                Client.JSONBodyKeys.password: "\(password!)"
            ]
        ]
        
        let url = Client.Constants.baseURLSecureString + Client.Methods.udacityPostSession
        
        /* 2. Make the request */
        taskForPOSTMethod(method: "udacity", urlString: url, jsonBody: jsonBody as [String : AnyObject]) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.domain)
            } else {
                print("Got session")
                guard let accountValues = JSONResult?[Client.JSONResponseKeys.account] as? [String: AnyObject] else {
                    print("Problem with \(Client.JSONResponseKeys.SessionID) in \(JSONResult)")
                    return
                }
                StudentLocation.sharedInstance.uniqueKey = accountValues["key"] as? String
                completionHandler(true, nil)
            }
        }
    }
    
    func logoutSession(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let url = Constants.baseURLSecureString + Client.Methods.udacityDeleteSession
        taskForDeleteMethod(urlString: url) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(false, "Logout Failed")
            } else {
                print("Sucessfully Logged Out")
                completionHandler(true, nil)
            }
        }
    }
    
    func getStudentLocations(completionHandler: @escaping (_ results: [StudentLocation]?, _ error: String?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            Client.ParameterKeys.limit: 100 as AnyObject,
            Client.ParameterKeys.skip: 400 as AnyObject,
            Client.ParameterKeys.order: "-updatedAt" as AnyObject
        ]
        
        let url = Client.Constants.baseParseSecureURL
        
        taskForGETMethod(method: "parse", urlString: url, parameters: parameters) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(nil, "Getting all student locations failed")
            } else {
                if let locations = JSONResult?[Client.JSONResponseKeys.locationResults] as? [[String: AnyObject]] {
                    StudentLocation.sharedInstance.studentLocationList = StudentLocation.locationsFromResults(results: locations)
                    completionHandler(StudentLocation.sharedInstance.studentLocationList, nil)
                } else {
                    completionHandler(nil, "JSONResult was empty")
                }
            }
        }
        
    }
    
    func postStudentLocation(completionHandler: @escaping (_ success:Bool, _ error: String?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let jsonBody : [String:AnyObject] = [
            Client.JSONResponseKeys.uniqueKey: "\(StudentLocation.sharedInstance.uniqueKey!)" as AnyObject,
            Client.JSONResponseKeys.firstName: "\(StudentLocation.sharedInstance.firstName!)" as AnyObject,
            Client.JSONResponseKeys.lastName: "\(StudentLocation.sharedInstance.lastName!)" as AnyObject,
            Client.JSONResponseKeys.mapString: "\(StudentLocation.sharedInstance.mapString!)" as AnyObject,
            Client.JSONResponseKeys.mediaURL: StudentLocation.sharedInstance.mediaURL! as AnyObject,
            Client.JSONResponseKeys.latitude: StudentLocation.sharedInstance.latitude! as AnyObject,
            Client.JSONResponseKeys.longitude: StudentLocation.sharedInstance.longitude! as AnyObject
        ]
        
        let url = Client.Constants.baseParseSecureURL
        
        taskForPOSTMethod(method: "parse", urlString: url, jsonBody: jsonBody) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(false, "Posting Student Location failed")
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
    func getUserData(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let url = Client.Constants.baseURLSecureString + Client.Methods.udacityUserData
        let value = StudentLocation.sharedInstance.uniqueKey!
        
        let newURL = url + value
        
        taskForGETMethod(method: "udacity", urlString: newURL, parameters: [String:AnyObject]()) { JSONResult, error in
            if let error = error {
                print(error)
                completionHandler(false, "Getting student data failed")
            } else {
                if let student = JSONResult?["user"] as? [String: AnyObject] {
                    StudentLocation.sharedInstance.firstName = student["first_name"] as? String
                    StudentLocation.sharedInstance.lastName = student["last_name"] as? String
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, "JSONResult was empty")
                }
            }
        }
    }
}
