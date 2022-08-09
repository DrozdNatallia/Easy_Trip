//
//  Constants.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation
import UIKit

struct Constants {
    
    static var baseURL = "https://api.travelpayouts.com/"
    // получение URL популярных направлений полета по данныи aviasales
    static var getPopularFlightsURL: String {
        return baseURL.appending("v1/city-directions")
    }
}
