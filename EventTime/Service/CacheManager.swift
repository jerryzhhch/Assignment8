//
//  CacheManager.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

typealias DataHandler = (Data?) -> Void
let Cache = CacheManager.shared

final class CacheManager {
    
    static let shared = CacheManager()
    private init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        return URLSession(configuration: config)
    }()
    
    private let cache = NSCache<NSString, NSData>()
    
    func download(from url: String, completion: @escaping DataHandler) {
        
        if let data = cache.object(forKey: url as NSString) {
            completion(data as Data)
            return
        }
        
        guard let final = URL(string: url) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: final) { [unowned self] (dat, _, _) in
            if let data = dat {
                
                self.cache.setObject(data as NSData, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }.resume()
    }
    
    
}
