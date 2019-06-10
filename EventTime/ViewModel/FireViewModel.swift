//
//  FireViewModel.swift
//  EventTime
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

let FireModel = FireViewModel.shared

class FireViewModel {
    
    static let shared = FireViewModel()
    private init() {}
    
    var favoritesID = Set<String>()
    
    var favorites = [Attraction]() {
        didSet {
            setFavoriteIDs()
            NotificationCenter.default.post(name: Notification.Name.FireNotification, object: nil)
        }
    }
    
    
    func getFire() {
        
        Fire.get { [unowned self] attrs in
            if let attractions = attrs {
                self.favorites = attractions
                print("Fire Count: \(self.favorites.count)")
            }
        }
    }
    
    private func setFavoriteIDs() {
        
        favorites.forEach({favoritesID.insert($0.id)})
        
    }
    
    
}
