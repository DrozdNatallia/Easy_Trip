//
//  Hotels.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 29.08.22.
//

import Foundation
import UIKit

struct Hotels  {
    var nameHotel: [String]
    var imageHotel: [UIImage]
    
    init(name: [String] = [], image: [UIImage] = []) {
        self.nameHotel = name
        self.imageHotel = image
    }
}

