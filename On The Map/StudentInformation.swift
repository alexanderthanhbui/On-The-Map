//
//  StudentInformation.swift
//  On The Map
//
//  Created by Hayne Park on 11/10/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var createdAt: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double?
    var longitude: Double?
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectId: String? = nil
    var uniqueKey: String? = nil
    var updatedAt: String? = nil
    var userFirstName: String? = nil
    var userLastName: String? = nil
    var userLong: Double? = nil
    var userLat: Double? = nil
    
    static var sharedInstance = StudentLocation()
    var studentLocationList = [StudentLocation]()
    
    init() {
        createdAt = ""
        firstName = ""
        lastName = ""
        latitude = 0.0
        longitude = 0.0
        mapString = ""
        mediaURL = ""
        objectId = ""
        uniqueKey = ""
        updatedAt = ""
        userFirstName = ""
        userLastName = ""
        userLong = 0.0
        userLat = 0.0
    }
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary[Client.JSONResponseKeys.createdAt] as? String
        firstName = dictionary[Client.JSONResponseKeys.firstName] as? String
        lastName  = dictionary[Client.JSONResponseKeys.lastName] as? String
        mapString = dictionary[Client.JSONResponseKeys.mapString] as? String
        mediaURL  = dictionary[Client.JSONResponseKeys.mediaURL] as? String
        objectId  = dictionary[Client.JSONResponseKeys.objectId] as? String
        updatedAt = dictionary[Client.JSONResponseKeys.updatedAt] as? String
        uniqueKey = dictionary[Client.JSONResponseKeys.uniqueKey] as? String
        
        latitude  = dictionary[Client.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[Client.JSONResponseKeys.longitude] as? Double
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects */
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
    
}
