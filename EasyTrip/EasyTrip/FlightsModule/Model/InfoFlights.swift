//
//  InfoFlights.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 18.08.22.
//

import UIKit

enum TypeDate {
    case price
    case arrave
    case depart
    case transfer
    case origin
    case destination
    case duration
    //  case image
}
struct InfoFlight {
    var arrayPrice: [Int]
    var arrayDepart: [Date]
    var arrayArrive: [String]
    var arrayTransfer: [Int]
    var arrayOrigin: [String]
    var arrayDestination: [String]
    var arrayDuration: [Int]
    var iconAirlines: [UIImage]
}
