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
    var url: [String]
    var row: [Int]
    
    init(name: [String] = [], price: [Int] = [], image: [UIImage] = [], url: [String] = [], row: [Int] = []) {
        self.nameExcursion = name
        self.price = price
        self.image = image
        self.url = url
        self.row = row
    }
}
