//
//  InfoFlights.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 18.08.22.
//

import UIKit
// хранение иформации о полетах
struct InfoFlight {
    var arrayPrice: [Int]
    var arrayDepart: [String]
    var arrayTransfer: [Int]
    var arrayOrigin: [String]
    var arrayDestination: [String]
    var arrayDuration: [Int]
    var iconAirlines: [UIImage]
    
    init(price: [Int] = [], depart: [String] = [], transfer: [Int] = [], origin: [String] = [], destination: [String] = [], duration: [Int] = [], iconAirlines: [UIImage] = []) {
        self.arrayPrice = price
        self.arrayDepart = depart
        self.iconAirlines = iconAirlines
        self.arrayDestination = destination
        self.arrayTransfer = transfer
        self.arrayOrigin = origin
        self.arrayDuration = duration
    }
}
