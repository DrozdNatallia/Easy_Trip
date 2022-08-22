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
    
    init(price: [Int] = [], depart: [Date] = [], arrive: [String] = [], transfer: [Int] = [], origin: [String] = [], destination: [String] = [], duration: [Int] = [], iconAirlines: [UIImage] = []) {
        self.arrayPrice = price
        self.arrayDepart = depart
        self.iconAirlines = iconAirlines
        self.arrayArrive = arrive
        self.arrayDestination = destination
        self.arrayTransfer = transfer
        self.arrayOrigin = origin
        self.arrayDuration = duration
    }
}
