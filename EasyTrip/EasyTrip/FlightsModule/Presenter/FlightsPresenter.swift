//
//  FlightsPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 16.08.22.
//

import UIKit
protocol FlightsViewPresenterProtocol: AnyObject {
    init(view: FlightsViewProtocol, info: InfoFlight, provaider: RestAPIProviderProtocol)
    func getFlightsInfo(originName: String, destinationName: String, date: String)
    func getArrayInfo(type: TypeDate) -> [Any]
    func getCodeCityByName(code: String, completion: @escaping (String) -> Void)
    func getImage() -> [UIImage]
    func getIconbyURL(url: String)
}


class FlightsViewPresenter: FlightsViewPresenterProtocol {
    private weak var view: FlightsViewProtocol?
    private var infoFlights: InfoFlight
    private var alamofireProvaider: RestAPIProviderProtocol!
    
    required init(view: FlightsViewProtocol, info: InfoFlight, provaider: RestAPIProviderProtocol) {
        self.view = view
        self.infoFlights = info
        self.alamofireProvaider = provaider
    }
    func getImage() -> [UIImage] {
        return infoFlights.iconAirlines
    }
    
    func getArrayInfo(type: TypeDate) -> [Any] {
        switch type {
        case .price:
            return  infoFlights.arrayPrice
        case .arrave:
            return  infoFlights.arrayArrive
        case .depart:
            return  infoFlights.arrayDepart
        case .transfer:
            return  infoFlights.arrayTransfer
        case .origin:
            return infoFlights.arrayOrigin
        case .destination:
            return infoFlights.arrayDestination
        case .duration:
            return infoFlights.arrayDuration
            //   case .image:
            //    return infoFlights.iconAirlines
        }
    }
    
    func getIconbyURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.infoFlights.iconAirlines.append(icon)
            } catch _ {
                print("error")
            }
        }
    }
    
    func getCodeCityByName(code: String, completion: @escaping (String) -> Void){
        alamofireProvaider.getNameCityByCode(code: code) { result in
            switch result {
            case .success(let value):
                guard let code = value.first?.code else { return }
                completion(code)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFlightsInfo(originName: String, destinationName: String, date: String) {
        alamofireProvaider.getFlightsInfo(origin: originName, date: date, destination: destinationName) { result in
            switch result {
            case .success(let value):
                guard let val = value.data else {return}
                for flight in val {
                    guard let price = flight.price, let depart = flight.departureAt, let transfer = flight.transfers, let origin = flight.origin, let destination = flight.destination, let duration = flight.duration, let icon = flight.airline else { return }
                    
                    self.infoFlights.arrayPrice.append(price)
                    self.infoFlights.arrayDepart.append(depart)
                    // self.infoFlights.arrayArrive.append(arrive)
                    self.infoFlights.arrayTransfer.append(transfer)
                    self.infoFlights.arrayOrigin.append(origin)
                    self.infoFlights.arrayDestination.append(destination)
                    self.infoFlights.arrayDuration.append(duration)
                    let urlIcon = Constants.getIconAirline + "\(icon)@2x.png"
                    self.getIconbyURL(url: urlIcon)
                    self.view?.setInfoFlights()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
