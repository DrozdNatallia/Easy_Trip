//
//  ViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
var alamofireProvaider = AlamofireProvaider()
    override func viewDidLoad() {
        super.viewDidLoad()
        getPopularFlights()
        getHotelsByCityName()
        getFlightInfo()
        getExcursionInfo()
    }


    fileprivate func getPopularFlights() {
        alamofireProvaider.getPopularFlights(country: "MOW") { result in
            switch result {
            case .success(let value):
                guard let date = value.data else {return}
                for flight in date.values {
                    // код страны прибытия
                    print(flight.destination)
                    guard let destination = flight.destination else {return}
                    self.alamofireProvaider.getNameCityByCode(code: destination) { result in
                        switch result {
                        case .success(let value):
                            guard let val = value.first?.name else {return}
                            // имя страны, полученное по коду
                            print(val)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    fileprivate func getHotelsByCityName() {
        alamofireProvaider.getHoltelsByCityName(name: "moscow") { result in
              switch result {
              case .success(let value):
                  guard let val = value.results, let hotels = val.hotels else {return}
                  for hotel in hotels {
                      // название отеля
                      print(hotel.fullName)
                      // по id, можно получить фото отеля
                      print("id: \(hotel.id)")
                  }

              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
    }
    
    
    fileprivate func getFlightInfo() {
        alamofireProvaider.getFlightsInfo(origin: "MOW", date: "2202-11", destination: "BCN")  { result in
          switch result {
          case .success(let value):
              guard let val = value.data else {return}
              for flight in val.values {
                  // все билеты по указанному направлению за месяц, можно ограничить
                  print("price: \(flight.price)")
                  print("дата возвращения: \(flight.returnAt)")
                  print("дата вылета: \(flight.departureAt)")
                  print("номер рейса: \(flight.flightNumber)")
              }
          case .failure(let error):
              print(error.localizedDescription)
          }
      }

    }
    
    fileprivate func getExcursionInfo() {
        alamofireProvaider.getExcursionInfo(codeCity: "LON") { result in
            switch result {
            case .success(let value):
                guard let val = value.data else {return}
                for exc in val {
                    // название экскурсий
                    print(exc.content)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

