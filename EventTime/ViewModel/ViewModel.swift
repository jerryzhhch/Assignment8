//
//  ViewModel.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


protocol ViewModelDelegate: class {
    func update()
}

class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    var attractions = [Attraction]() {
        didSet {
            delegate?.update()
        }
    }
    
    var filteredAttractions = [Attraction]() {
        didSet {
            delegate?.update()
        }
    }
    
    func get() {
        
        Service.get { [unowned self] attrs in
            guard let attractions = attrs else {
                return
            }
            self.attractions = attractions
            print("Attr Count: \(self.attractions.count)")
        }
    }
    
    
}
