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
    
    init(name: [String] = [], price: [Int] = [] ) {
        self.nameExcursion = name
        self.price = price
    }
}
