//
//  LastService.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

typealias AttractionHandler = ([Attraction]?) -> Void
let Service = LastService.shared

final class LastService {
    
    
    static let shared = LastService()
    private init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        return URLSession(configuration: config)
    }()
    
    func get(_ completion: @escaping AttractionHandler) {
        
        
        let urlString = LastAPI.lastUrl
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { (dat, _, _) in
            
            if let data = dat {
                
                do {
                    let jsonObject = try JSONDecoder().decode(AttractionResult.self, from: data)
                    let attrs = jsonObject.embedded.attractions
                    completion(attrs)
                } catch {
                    completion(nil)
                    print("decode error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
}
