//
//  InfoHotel.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import Foundation
import UIKit
// хранение инфы отелей
struct InfoHotel {
    var arrayNameHotel: [String]
    var arrayImages: [UIImage]
    var url: [String]
    var row: [Int]
    init(name: [String] = [], image: [UIImage] = [], url: [String] = [], row: [Int] = []) {
        self.arrayImages = image
        self.arrayNameHotel = name
        self.url = url
        self.row = row
    }
    
}
