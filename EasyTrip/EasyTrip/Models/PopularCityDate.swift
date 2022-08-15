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
    private var arrayNameCity: [String] = []
    private var arrayImageCity: [UIImage] = []
    
    mutating func addNewName(name: String) {
        arrayNameCity.append(name)
    }
    mutating func addNewImage(image: UIImage) {
        arrayImageCity.append(image)
    }
    func getarrayNameCity() -> [String] {
        return arrayNameCity
    }
    func getarrayImageCity() -> [UIImage] {
        return arrayImageCity
    }
}
