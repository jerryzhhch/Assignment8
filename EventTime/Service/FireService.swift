//
//  FireService.swift
//  EventTime
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

let Fire = FireService.shared

final class FireService {
    
    static let shared = FireService()
    private init() {}
    
    
    let uid = Auth.auth().currentUser?.uid
    lazy var userRef = Database.database().reference(withPath: uid ?? Constants.Keys.user.rawValue)
    lazy var attrRef = userRef.child(Constants.Keys.attractions.rawValue)
    
    
    //MARK: Save
    func save(_ attr: Attraction) {
        
        attrRef.child(attr.id).setValue(attr.toDictionary)
        
        print("Saved Attraction: \(attr.name)")
    }
    
    
    
    //MARK: Delete
    func remove(_ attr: Attraction) {
        
        attrRef.child(attr.id).removeValue()
        
        print("Removed Attraction: \(attr.name)")
        
    }
    
    
    
    //MARK: Load
    
    func get(_ completion: @escaping AttractionHandler) {
        
        var attractions = [Attraction]()
        
        
        attrRef.observeSingleEvent(of: .value) { snapshot in
            
            for snap in snapshot.children {
                
                let data: DataSnapshot = snap as! DataSnapshot
                
                guard let attr = Attraction(snapshot: data) else {
                    continue
                }
                
                attractions.append(attr)
                
            }
            
            completion(attractions)
        }
    }

    
}
