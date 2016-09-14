//
//  NSDate+Utilities.swift
//  PopIn
//
//  Created by Hanny Aly on 9/1/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation
import AFDateHelper

extension NSDate {
    
    
    class func fromDate(date: String?) -> NSDate? {
        
        if let date = date {
            return NSDate(fromString:  date, format: .ISO8601(nil))
        }
        return nil
    }
    
    func fromTimestamp(timestamp: String) -> NSDate {
        
        return NSDate(fromString: timestamp, format: .ISO8601(nil))
        
    }
    
    
    
    class func stillLegal(date: NSDate) -> Bool {
        
        let numberOfDays = 2
        let numberOfHours = 24
        let legalTime = 3600 * numberOfHours * numberOfDays
        
        let todaysDate = NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)
        let seconds    = date.secondsBeforeDate(todaysDate)
        
        return seconds < legalTime ? true : false
    }

    
    
    func timeAgoFromDate(date: NSDate) -> String {
        
        let todaysDate = NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)
        
        let seconds = date.secondsBeforeDate(todaysDate)
        let minutes = date.minutesBeforeDate(todaysDate)
        let hours   = date.hoursBeforeDate(todaysDate)
        let days    = date.daysBeforeDate(todaysDate)
    
        if todaysDate.compare(date) == .OrderedAscending {
            print("Error in timeAgoFromDate, Dates are not correct ")
            return ""
        }
        
        if seconds < 60 {
            if seconds < 5 {
             return "Now"
            } else {
                return "\(seconds)s"
            }
        }
        if minutes < 60 {
             return "\(minutes)m"
        }
        if hours < 24 {
            return "\(hours)h"
        }
        
        return "\(days)d"
    }
    
    
    func timeAgoFromTimestamp(timestamp: String) -> String {

        let date = NSDate(fromString: "/Date(\(timestamp))/", format: .DotNet)

        return timeAgoFromDate(date)

    }
    
    // Returns time left in day as a percent
    func percentOfDayLeft(date: NSDate) -> CGFloat {
        
        let todaysDate = NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)
        
        if todaysDate.compare(date) == .OrderedAscending {
            print("Error in timeAgoFromDate, Dates are not correct ")
            return 0
        }
        
//        let minutes = CGFloat( date.minutesBeforeDate(todaysDate) )
//        let minutesInDay:CGFloat = 60 * 24
//        return minutes / minutesInDay
//        
        
        let hours = CGFloat(date.hoursBeforeDate(todaysDate))
        
        return hours / 24
    }
    
     
        
        
}



