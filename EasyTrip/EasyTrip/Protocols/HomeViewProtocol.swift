//
//  HomeViewProtocol.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 13.08.22.
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    func setImageCity(image: [UIImage])
    func getNamePopularCityByCode(city: [String], isName: Bool)
    func getPopularFlights(code: String)
}
