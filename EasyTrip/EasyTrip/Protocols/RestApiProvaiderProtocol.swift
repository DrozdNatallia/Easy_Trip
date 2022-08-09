//
//  RestApiProvaiderProtocol.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation


protocol RestAPIProviderProtocol {
    // получение данных
    func getPopularFlights(country: String, completion: @escaping (Result<PopularFlight, Error>) -> Void)
    func getHoltelsByCityName(name: String, completion: @escaping (Result<HotelsData, Error>) -> Void)
    func getFlightsInfo(origin: String, date: String, destination: String, completion: @escaping (Result<FligthsInfo, Error>) -> Void)
    
}

