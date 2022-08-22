//
//  HotelsData.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation
import UIKit

//struct HotelsData: Codable {
//    let results: Results?
//    let status: String?
//}
//struct Results: Codable {
//    let locations: [LocationElement]?
//    let hotels: [Hotel]?
//}
//struct Hotel: Codable {
//    let score: Int?
//    let fullName, locationName: String?
//    let locationID: Int?
//    let id: String?
//    let location: HotelLocation?
//    let label: String?
//
//    enum CodingKeys: String, CodingKey {
//        case score = "_score"
//        case fullName, locationName
//        case locationID = "locationId"
//        case id, location, label
//    }
//}
//
//struct HotelLocation: Codable {
//    let lon, lat: Double?
//}
//
//struct LocationElement: Codable {
//    let score: Int?
//    let hotelsCount, fullName, countryName, countryCode: String?
//    let id: String?
//    let iata: [String]?
//    let location: LocationLocation?
//    let cityName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case score = "_score"
//        case hotelsCount, fullName, countryName, countryCode, id, iata, location, cityName
//    }
//}
//
//struct LocationLocation: Codable {
//    let lon, lat: String?
//}


struct HotelsData: Codable {
    let hotelID, locationID: Int?
    let location: Location?
    let hotelName: String?
    let stars: Int?
    let priceFrom: Double?
    let pricePercentile: [String: Double]?
    let priceAvg: Double?

    enum CodingKeys: String, CodingKey {
        case hotelID = "hotelId"
        case locationID = "locationId"
        case location, hotelName, stars, priceFrom, pricePercentile, priceAvg
    }
}

// MARK: - Location
struct Location: Codable {
    let country, name: String?
    let state: String?
    let geo: Geo?
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lon: Double?
}
