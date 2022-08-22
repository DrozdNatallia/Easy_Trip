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
    func getHoltelsByCityName(name: String, chekIn: String, checkOut: String, adults: Int, completion: @escaping (Result<[HotelsData], Error>) -> Void)
    func getFlightsInfo(origin: String, date: String, destination: String, completion: @escaping (Result<FligthsInfo, Error>) -> Void)
    func getExcursionInfo(codeCity: String, completion: @escaping (Result<ExcursionInfo, Error>) -> Void)
    func getNameCityByCode(code: String, completion: @escaping (Result<[Autocomplete], Error>) -> Void)
}

