//
//  Hotels.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 29.08.22.
//

import Foundation
import UIKit

struct Favourites  {
    var name: [String]
    var image: [UIImage]
    
    init(name: [String] = [], image: [UIImage] = []) {
        self.name = name
        self.image = image
    }
}

