//
//  Autocomplete.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 10.08.22.
//

import Foundation
import UIKit

struct Autocomplete: Codable {
    let type: String?
    let code, name, countryCode, countryName: String?
    let stateCode: String?
    let coordinates: Coordinates?
    let indexStrings: [String]?
    let weight: Int?
    let cases, countryCases, mainAirportName: String?

    enum CodingKeys: String, CodingKey {
        case type, code, name
        case countryCode = "country_code"
        case countryName = "country_name"
        case stateCode = "state_code"
        case coordinates
        case indexStrings = "index_strings"
        case weight, cases
        case countryCases = "country_cases"
        case mainAirportName = "main_airport_name"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lon, lat: Double?
}
