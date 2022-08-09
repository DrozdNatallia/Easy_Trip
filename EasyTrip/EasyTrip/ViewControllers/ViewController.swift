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
    }


    fileprivate func getPopularFlights() {
        alamofireProvaider.getPopularFlights(country: "MOW") { [weak self] result in
          //  guard let self = self else { return }
            switch result {
            case .success(let value):
                guard let date = value.data else {return}
                for flight in date.values {
                    print(flight.destination)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    fileprivate func getHotelsByCityName() {
        alamofireProvaider.getHoltelsByCityName(name: "moscow") { [weak self] result in
            //  guard let self = self else { return }
              switch result {
              case .success(let value):
                  guard let val = value.results, let hotels = val.hotels else {return}
                  for hotel in hotels {
                      print(hotel.fullName)
                  }

              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
    }
    
    
    fileprivate func getFlightInfo() {
        alamofireProvaider.getFlightsInfo(origin: "MOW", date: "2202-11", destination: "BCN")  { [weak self] result in
        //  guard let self = self else { return }
          switch result {
          case .success(let value):
              print(value)
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
    
}

