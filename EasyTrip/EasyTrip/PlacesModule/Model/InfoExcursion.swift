//
//  InfoExcursion.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 23.08.22.
//

import UIKit

struct InfoExcursion {
    var nameExcursion: [String]
    var price: [Int]
    var image: [UIImage]
    
    init(name: [String] = [], price: [Int] = [], image: [UIImage] = [] ) {
        self.nameExcursion = name
        self.price = price
        self.image = image
    }
}
