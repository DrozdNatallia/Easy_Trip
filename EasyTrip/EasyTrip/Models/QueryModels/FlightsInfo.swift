//
//  FlightsInfo.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation
import UIKit

struct FligthsInfo: Codable {
    let success: Bool?
    let data: [DateElements]?
    let currency: String?
}


struct DateElements: Codable {
    let origin, destination, originAirport, destinationAirport: String?
    let price: Int?
    let airline, flightNumber: String?
    let departureAt, returnAt: String?
    let transfers, returnTransfers, duration: Int?
    let link: String?

    enum CodingKeys: String, CodingKey {
        case origin, destination
        case originAirport = "origin_airport"
        case destinationAirport = "destination_airport"
        case price, airline
        case flightNumber = "flight_number"
        case departureAt = "departure_at"
        case returnAt = "return_at"
        case transfers
        case returnTransfers = "return_transfers"
        case duration, link
    }
}
