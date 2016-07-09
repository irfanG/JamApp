//
//  UserDefaultsManager.swift
//  DzematApp
//
//  Created by Irfan Godinjak on 03/07/16.
//  Copyright © 2016 eu.devlogic. All rights reserved.
//
//
import Foundation

/// A namespace for NSUserDefault keys.
enum UserDefault: String {
    /// The token by which Apple Push Notification Service (APNS) references the device.
    case DeviceToken
    /// A `Bool` which indicates if push notifications are permitted on the device (i.e. a user has answered the iOS system prompt asking the user to allow notifications).
    case PushNotificationsPermitted
    /// This means something very similar to DeviceToken existing.
    case PushNotificationsEnabled
    
    // Last time init was called
    case LastInitAlertTime = "lastInitAlertTime"
    
    // stores the deviceID
    case DeviceId = "deviceId"
    
    // stored the user session info
    case UserSession = "userSession"
    
    // whether the user is loggedIn or not
    case LoggedIn = "loggedIn"
    
    // access token expiration time
    case AccessTokenExpiration
    
    // stores current api base url
    case ApiBaseUrl = "apiBaseUrl"
    
    // stores current web base url
    case WebBaseUrl = "webBaseUrl"
    
    // session handlers
    case SessionStartTime = "SessionStartTime"
    
    case PreviousSessionEndTime = "PreviousSessionEndTime"
    
    case PreviousSessionId = "PreviousSessionId"
    
    case SessionLength = "SessionLength"
    
    // previously seen id handlers
    case PreviouslySeenIds = "PreviouslySeenIds"
    
}

// in seconds
enum Frequency: NSTimeInterval {
    case OncePerMinute = 60
    case OncePerDay = 86400
    case OncePerWeek = 604800
}

class UserDefaultManager {
    
    /**
     Save last init alert time
     */
    class func saveTime(key: UserDefault, time: NSDate=NSDate()) {
        // encode and store data
        let encodedTime : NSData = NSKeyedArchiver.archivedDataWithRootObject(time)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(encodedTime, forKey: key.rawValue)
        
        defaults.synchronize()
    }
    
    /**
     Checks if we have an alert time
     
     - returns: whether a user is logged in
     */
    class func readTime(key: UserDefault) -> NSDate? {
        if let encodedTime = NSUserDefaults.standardUserDefaults().valueForKey(key.rawValue) as? NSData, let oldTime = NSKeyedUnarchiver.unarchiveObjectWithData(encodedTime)! as? NSDate {
            return oldTime
        }
        return nil
    }
    
    /**
     remove the saved default
     
     - parameter key: key to remove
     */
    class func clearTime(key: UserDefault) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key.rawValue)
    }
    
    /**
     Only return true when it have been greater than frequency seconds between last call and now.
     
     will save new time on every true return
     
     - parameter key:       the key to check
     - parameter frequency: how often in seconds
     
     - returns: whether frequency time has elapsed or not
     */
    class func timePeriodHasElapsed(key: UserDefault, frequency: Frequency) -> Bool {
        if let oldTime = readTime(key) where NSDate().compare(NSDate(timeInterval: frequency.rawValue, sinceDate: oldTime)) == .OrderedAscending {
            return false
        } else {
            saveTime(key)
            return true
        }
    }
    
    /**
     save the length, adding it to the old length if it exists
     
     - parameter key:       the key to store at
     - parameter newLength: how many seconds to add
     */
    class func saveLength(key: UserDefault, newLength: Double) {
        let currentLength = NSUserDefaults.standardUserDefaults().doubleForKey(key.rawValue) // returns 0 if nil
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setDouble(currentLength + newLength, forKey: key.rawValue)
        
        defaults.synchronize()
    }
    
    /**
     clear length
     
     - parameter key:       the key to store at
     */
    class func clearLength(key: UserDefault) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setDouble(0.0, forKey: key.rawValue)
        
        defaults.synchronize()
    }
    
    /**
     read the length
     - parameter key:       the key to read at
     */
    class func readLength(key: UserDefault) -> Double {
        return NSUserDefaults.standardUserDefaults().doubleForKey(key.rawValue)
    }
    
    /**
     save the length, adding it to the old length if it exists
     
     - parameter key:       the key to store at
     - parameter newLength: how many seconds to add
     */
    class func saveDictionary(key: UserDefault, dictionary: [String : String]) {
        let encodedDictionary : NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(encodedDictionary, forKey: key.rawValue)
        
        defaults.synchronize()
    }
    
    /**
     clear length
     
     - parameter key:       the key to store at
     */
    class func clearDictionary(key: UserDefault) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key.rawValue)
    }
    
    /**
     read the length
     - parameter key:       the key to read at
     */
    class func readDictionary(key: UserDefault) -> [String : String] {
        if let encodedDictionary = NSUserDefaults.standardUserDefaults().valueForKey(key.rawValue) as? NSData, let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(encodedDictionary)! as? [String : String] {
            return dictionary
        }
        return [String : String]()
    }
    
}