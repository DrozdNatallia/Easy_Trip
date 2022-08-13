//
//  HomeViewPresenterProtocol.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 13.08.22.
//

import Foundation
import UIKit

protocol HomeViewPresenterProtocol {
    func getImagebyURL(url: String)
    func getNamePopularCityByCode(code: String, isName: Bool)
    func getPopularFlights(nameDirection: String)
}
