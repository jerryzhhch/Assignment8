//
//  SearchCollectionCell.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var searchCollectionImage: UIImageView!
    
    
    static let identifier = "SearchCollectionCell"

    
    func configure(with attr: Attraction) {
        
        guard let url = attr.imageUrl else {
            searchCollectionImage.image = #imageLiteral(resourceName: "ph")
            return
        }
        
        Cache.download(from: url) { [unowned self] dat in
            if let data = dat, let image = UIImage(data: data) {
                self.searchCollectionImage.image = image
            }
        }
    }
}
