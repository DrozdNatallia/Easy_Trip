//
//  AlamofireProvaider.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import Foundation
import Alamofire
import UIKit

class AlamofireProvaider: RestAPIProviderProtocol {

    // добавление параметров в запрос
    private func addParams(queryItems: [String: String]) -> [String: String] {
        var params: [String: String] = [:]
        params = queryItems
        params["token"] = "3f4cc4a2c7e931bcd04d42a0850f84da"
        return params
    }
    // получение популярных полетов
    func getPopularFlights(country: String, completion: @escaping (Result<PopularFlight, Error>) -> Void) {
        let params = addParams(queryItems: ["origin" : country, "currency" : "usd", "limit" : "5"])
        
        AF.request(Constants.getPopularFlightsURL, method: .get, parameters: params).responseDecodable(of: PopularFlight.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    //query=moscow&lang=ru&lookFor=both&limit=1
    
    func getHoltelsByCityName(name: String, completion: @escaping (Result<HotelsData, Error>) -> Void) {
        let params = addParams(queryItems: ["query" : "moscow", "lang" : "ru", "lookFor" : "both", "limit" : "5"])
        AF.request(Constants.getHotelsByNameCity, method: .get, parameters: params).responseDecodable(of: HotelsData.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
