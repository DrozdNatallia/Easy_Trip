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
    
}
