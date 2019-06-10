//
//  Attraction.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AttractionResult: Decodable {
    let embedded: AttractionInfo
    
    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct AttractionInfo: Decodable {
    let attractions: [Attraction]
}



class Attraction: Decodable {
    
    let name: String
    let url: String
    let id: String
    let images: [Image]
    let classifications: [Classification]
    
    init?(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String:Any] else {
            return nil
        }
        
        self.name = value[Constants.Attraction.name.rawValue] as! String
        self.url = value[Constants.Attraction.url.rawValue] as! String
        self.id = value[Constants.Attraction.id.rawValue] as! String
        
        let imageURL = value[Constants.Attraction.image.rawValue] as! String
        let genre = value[Constants.Attraction.genre.rawValue] as! String
        
        self.images = [Image(url: imageURL)]
        self.classifications = [Classification(genre: Genre(name: genre))]
    }
    
}




struct Image: Decodable {
    
    let ratio: String
    let url: String
    
    init(ratio: String = "16_9", url: String) {
        self.url = url
        self.ratio = ratio
    }
}


struct Classification: Decodable {
    let genre: Genre
}

struct Genre: Decodable {
    let name: String
}
