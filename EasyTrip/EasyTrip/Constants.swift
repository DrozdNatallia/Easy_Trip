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
    // получение URL для запросов
    static var getHotelsByNameCity = "https://engine.hotellook.com/api/v2/cache.json"
    static var autocompleteURL = "https://autocomplete.travelpayouts.com/places2"
    static var getImageCityByURL = "https://photo.hotellook.com/static/cities/"
    static var getPhotoHotels = "https://photo.hotellook.com/image_v2/crop/h"
    static var getIconAirline = "https://pics.avs.io/120/35/"
    static var getPopularFlightsURL: String {
        return baseURL.appending("v1/city-directions")
    }
    static var getFlightsInfo: String {
        return baseURL.appending("aviasales/v3/prices_for_dates")
    }
    static var getExcursionInfoURL: String {
        return baseURL.appending("weatlas/v1/search_prices_by_iata")
    }
}
