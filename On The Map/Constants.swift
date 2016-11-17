//
//  Constants.swift
//  On The Map
//
//  Created by Hayne Park on 11/4/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import Foundation
import UIKit

extension Client {

// MARK: - Constants

struct Constants {
        
    /* Constants for Udacity */
    static let baseURLSecureString = "https://www.udacity.com/api/"
    
    /* Constants for Parse */
    static let baseParseSecureURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
}

// Methods
struct Methods {
    static let udacityUserData = "users/"
    static let udacityPostSession = "session"
    static let udacityDeleteSession = "session"
        
    static let parseStudentLocation = "StudentLocation"
    static let updateStudentLocation = "StudentLocation"
}

// Parameter Keys
struct ParameterKeys {
    static let limit = "limit"
    static let skip = "skip"
    static let order = "order"
        
    static let id = "id"
}

// JSON Body Keys
struct JSONBodyKeys {
    static let udacity = "udacity"
    static let username = "username"
    static let password = "password"
}

// JSON Response Keys
struct JSONResponseKeys {
    static let SessionID = "session"
    static let account = "account"
    static let locationResults = "results"
    
    static let createdAt = "createdAt"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let mapString = "mapString"
    static let mediaURL = "mediaURL"
    static let objectId = "objectId"
    static let uniqueKey = "uniqueKey"
    static let updatedAt = "updatedAt"
    }
}
