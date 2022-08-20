//
//  InfoHotel.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import Foundation
import UIKit

struct InfoHotel {
    var arrayNameHotel: [String] = []
    var arrayImages: [UIImage] = []
    
    init(name: [String] = [], image: [UIImage] = []) {
        self.arrayImages = image
        self.arrayNameHotel = name
    }
}
