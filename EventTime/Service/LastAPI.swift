//
//  LastAPI.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct LastAPI {
    
    
    static let base = "https://app.ticketmaster.com/discovery/v2/attractions.json?countryCode=US"
    static let key = "&apikey=ANCuo4a3upOEy5I99090VUd9jtNW1XKQ"
    
    
    static var lastUrl: String {
        return base + key
    }
    
    
}
