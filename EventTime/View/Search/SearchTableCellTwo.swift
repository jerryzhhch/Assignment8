//
//  SearchTableCellTwo.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SearchTableCellTwo: UITableViewCell {

    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchMainLabel: UILabel!
    @IBOutlet weak var searchSubLabel: UILabel!
    @IBOutlet weak var searchFavoriteButton: UIButton!
    
    static let identifier = "SearchTableCellTwo"
    
    
    func configure(with attr: Attraction) {
        
        searchMainLabel.text = attr.name
        searchSubLabel.text = attr.classifications.first?.genre.name
        
        guard let url = attr.imageUrl else {
            searchImage.image = #imageLiteral(resourceName: "ph")
            return
        }
        
        Cache.download(from: url) { [unowned self] dat in
            if let data = dat, let image = UIImage(data: data) {
                self.searchImage.image = image
            }
        }
    }
    
}
