//
//  Date+Extension.swift
//  PickUpUser
//
//  Created by hb on 31/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
extension Date {
    /// Display time in seconds, min, hour, days
    ///
    /// - Parameter second: seconds
    /// - Returns: Time string
    func timeAgoDisplay(second: Int) -> String {
        let secondsAgo = second
        let sec = 1
        let minute = 60 * sec  //60
        let hour = 60 * minute // 3600
        let day = 24 * hour // 86400
        let week = 7 * day  // 604800
        
        if secondsAgo < minute {
            return "Just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hr(s) ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) day(s) ago"
        }
        return "\(secondsAgo / week) week(s) ago"
    }
}
