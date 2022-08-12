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
    static var getFlightsInfo: String {
        return baseURL.appending("v1/prices/calendar")
    }
    
    static var getExcursionInfoURL: String {
        return baseURL.appending("weatlas/v1/search_prices_by_iata")
    }
    
    static var getHotelsByNameCity = "https://engine.hotellook.com/api/v2/lookup.json"
    
    static var autocompleteURL = "https://autocomplete.travelpayouts.com/places2"
}




