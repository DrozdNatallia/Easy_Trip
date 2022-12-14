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
    private var key: String? {
        get {
            Bundle.main.infoDictionary?["API_KEY"] as? String
        }
    }
    // получение имени
    func getNameCityByCode(code: String, completion: @escaping (Result<[Autocomplete], Error>) -> Void) {
        let params = addParams(queryItems: ["locale" : "en", "types[]" : "city" , "term" : code])
        AF.request(Constants.autocompleteURL, method: .get, parameters: params).responseDecodable(of: [Autocomplete].self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // добавление параметров в запрос
    private func addParams(queryItems: [String: String]) -> [String: String] {
        var params: [String: String] = [:]
        params = queryItems
        if let key = key  {
            params["token"] = "\(key)"
            return params
        }
        return params
    }
    // получение популярных полетов
    func getPopularFlights(country: String, completion: @escaping (Result<PopularFlight, Error>) -> Void) {
        let params = addParams(queryItems: ["origin": country, "currency" : "usd", "limit" : "5"])
        AF.request(Constants.getPopularFlightsURL, method: .get, parameters: params).responseDecodable(of: PopularFlight.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // информация об отелях
    func getHoltelsByCityName(name: String, chekIn: String, checkOut: String, adults: Int, completion: @escaping (Result<[HotelsData], Error>) -> Void) {
        let params = addParams(queryItems: ["location" : name, "lang" : "en", "currency" : "usd", "limit" : "10", "checkIn" : chekIn, "checkOut" : checkOut, "adults" : "\(adults)"])
        AF.request(Constants.getHotelsByNameCity, method: .get, parameters: params).responseDecodable(of: [HotelsData].self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
// информация о полетах
    func getFlightsInfo(origin: String, date: String, destination: String, completion: @escaping (Result<FligthsInfo, Error>) -> Void) {
        let params = addParams(queryItems: ["origin" : origin, "destination" : destination, "currency" : "usd",  "departure_at" : date, "sorting" : "price", "direct" : "true", "limit" : "10"])
        AF.request(Constants.getFlightsInfo, method: .get, parameters: params).responseDecodable(of: FligthsInfo.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getExcursionInfo(codeCity: String, start: String, end: String, adults: String, child: String, completion: @escaping (Result<ExcursionInfo, Error>) -> Void) {
        let params = addParams(queryItems: ["code" : codeCity, "limit" : "5", "language" : "ru", "from_date" : start, "to_date" : end, "adults_count" : adults, "children_count" : child, "currency" : "usd"])
        
        AF.request(Constants.getExcursionInfoURL, method: .get, parameters: params).responseDecodable(of: ExcursionInfo.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
