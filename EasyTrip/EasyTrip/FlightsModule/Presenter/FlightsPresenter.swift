//
//  FlightsPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 16.08.22.
//

import UIKit
protocol FlightsViewPresenterProtocol: AnyObject {
    init(view: FlightsViewProtocol, info: InfoFlight, provaider: RestAPIProviderProtocol, router: RouterProtocol, location: String, icon: UIImage?)
    func getFlightsInfo(originName: String, destinationName: String, date: String)
    func getCodeCityByName(code: String, completion: @escaping (String) -> Void)
    func getImage() -> [UIImage]
    func getIconbyURL(url: String)
    func getLocation()
    func tapOnButtonHotels(location: String, icon: UIImage)
    func tapOnButtonPlaces(location: String, icon: UIImage)
    func tapOnButtonExplore()
    func getIconImage()
    func configure(cell: FlightsCellProtocol, row: Int)
    func getArrayFligts() -> [String]
}


final class FlightsViewPresenter: FlightsViewPresenterProtocol {
    private weak var view: FlightsViewProtocol?
    private var infoFlights: InfoFlight
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var router: RouterProtocol?
    private var location: String?
    private var icon: UIImage?
    
    required init(view: FlightsViewProtocol, info: InfoFlight, provaider: RestAPIProviderProtocol, router: RouterProtocol, location: String, icon: UIImage?) {
        self.view = view
        self.infoFlights = info
        self.alamofireProvaider = provaider
        self.router = router
        self.location = location
        self.icon = icon

    }
    // получение иконки пользователя
    func getIconImage() {
        guard let image = icon else {return}
        self.view?.updateIcon(image: image)
    }
    //переход на HotelsViewController
    func tapOnButtonHotels(location: String, icon: UIImage) {
        router?.showHotelsModule(location: location, icon: icon)
    }
    // переход на placesViewController
    func tapOnButtonPlaces(location: String, icon: UIImage) {
        router?.showPlacesModule(location: location, icon: icon)
    }
    // возвращение на rootViewController
    func tapOnButtonExplore() {
        router?.popToRoot()
    }
    // получение локации
    func getLocation(){
        guard let location = location else { return }
        view?.setLocation(location: location)
    }
    // получение логотипов
    func getImage() -> [UIImage] {
        return infoFlights.iconAirlines
    }
    // получение массивов
    func getArrayFligts() -> [String] {
        infoFlights.arrayOrigin
    }
    //получение логотипов по ссылке
    func getIconbyURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.infoFlights.iconAirlines.append(icon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    // получение кода города
    func getCodeCityByName(code: String, completion: @escaping (String) -> Void){
        alamofireProvaider.getNameCityByCode(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                guard let code = value.first?.code else { return }
                completion(code)
            case .failure(let error):
                self.view?.stopAnimation()
                print(error.localizedDescription)
            }
        }
    }
    func configure(cell: FlightsCellProtocol, row: Int) {
        let durationInMin = infoFlights.arrayDuration[row]
        let flightTime = "in flight \(durationInMin.minToTime())"
        let originCity = "From\n \(infoFlights.arrayOrigin[row])"
        let destinationCity = "To\n \(infoFlights.arrayDestination[row])"
        let departureTime = "departure\n \(infoFlights.arrayDepart[row])"
        let transferCount = "transfer\n \(infoFlights.arrayTransfer[row])"
        let icon = infoFlights.iconAirlines[row]
        let priceFlight = "\(infoFlights.arrayPrice[row])$"
        cell.fillField(originCity: originCity, destinationCity: destinationCity, priceFlights: priceFlight, transferFlight: transferCount, flightTime: flightTime, icon: icon, depart: departureTime)
    }
    // получение информации о полетах
    func getFlightsInfo(originName: String, destinationName: String, date: String) {
        alamofireProvaider.getFlightsInfo(origin: originName, date: date, destination: destinationName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                guard let val = value.data else {return}
                for flight in val {
                    guard let price = flight.price, let depart = flight.departureAt, let transfer = flight.transfers, let origin = flight.origin, let destination = flight.destination, let durationInMin = flight.duration, let icon = flight.airline else { return }
                    self.infoFlights.arrayPrice.append(price)
                    self.infoFlights.arrayDepart.append(depart.convertDateFromIsoToTime())
                    self.infoFlights.arrayTransfer.append(transfer)
                    self.infoFlights.arrayOrigin.append(origin)
                    self.infoFlights.arrayDestination.append(destination)
                    self.infoFlights.arrayDuration.append(durationInMin)
                    let urlIcon = Constants.getIconAirline.appending("\(icon)@2x.png")
                    self.getIconbyURL(url: urlIcon)
                    self.view?.setInfoFlights()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

