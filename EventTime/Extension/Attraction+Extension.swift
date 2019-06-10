//
//  Attraction+Extension.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


extension Attraction {
    
    var imageUrl: String? {
        
        guard let imageObject = self.images.first(where: {$0.ratio == "16_9" && $0.url.contains( "RETINA_PORTRAIT_16_9")}) else {
            
            return nil
        }
        
        
        return imageObject.url
    }
    
    
    var toDictionary: [String: String] {
        return ["name":self.name, "url":self.url, "id":self.id, "image":self.imageUrl!, "genre": self.classifications.first!.genre.name]
    }
    
}
