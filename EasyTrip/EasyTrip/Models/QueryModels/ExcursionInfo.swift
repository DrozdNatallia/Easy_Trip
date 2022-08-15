//
//  ExcursionInfo.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation
import UIKit

struct ExcursionInfo: Codable {
    let data: [ExcursionDate]?
    let success: Bool?
}
struct ExcursionDate: Codable {
    let excursionID, price: Int?
    let currency, content, excursionType, activityType: String?
    let cityIata, countryIata: String?
    let link: String?
    let photo: String?
    let duration: String?
    let availableDates: [String]?

    enum CodingKeys: String, CodingKey {
        case excursionID = "excursion_id"
        case price, currency, content
        case excursionType = "excursion_type"
        case activityType = "activity_type"
        case cityIata = "city_iata"
        case countryIata = "country_iata"
        case link, photo, duration
        case availableDates = "available_dates"
    }
}
