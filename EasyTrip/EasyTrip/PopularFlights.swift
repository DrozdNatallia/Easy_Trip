//
//  File.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation
import UIKit


struct PopularFlight: Codable {
    let success: Bool?
    let data: [String : Datum]?
    let currency: String?
}

struct Datum: Codable {
    let origin, destination: String?
    let price: Int?
    let airline: String?
    let flightNumber: Int?
    let departureAt, returnAt: String?
    let transfers: Int?
    let expiresAt: String?
    
    enum CodingKeys: String, CodingKey {
        case origin, destination, price, airline
        case flightNumber = "flight_number"
        case departureAt = "departure_at"
        case returnAt = "return_at"
        case transfers
        case expiresAt = "expires_at"
    }
}

