//
//  PopularCity.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 10.08.22.
//

import Foundation
import UIKit
// модель для хранения данных о популярных направлениях
struct PopulareCityDate {
    var arrayNameCity: [String]
    var arrayImageCity: [UIImage]
    var width: Int
    var height: Int
    
    init (name: [String] = [], image: [UIImage] = [], width: Int, height: Int) {
        self.arrayImageCity = image
        self.arrayNameCity = name
        self.width = width
        self.height = height
    }
}
