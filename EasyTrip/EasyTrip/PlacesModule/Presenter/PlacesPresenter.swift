//
//  PlacesPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 23.08.22.
//

import UIKit
protocol PlacesViewPresenterProtocol {
    func getCodeByNameCity(code: String)
    func getExcursionInfo(code: String, start: Date, end: Date, adults: String, child: String)
    func getArrayNameExc() -> [String]
    func convertDateToString(date: Date) -> String
    func getArrayPrice() -> [Int]
    func getArrayImage() -> [UIImage]
    func getPhotoByURL(url: String)
    func clearArray()
    func tapOnButtonHotels(location: String)
    func tapOnButtonFlights(location: String)
    func tapOnButtonExplore()
    func getLocation()
}

final class PlacesViewPresenter: PlacesViewPresenterProtocol {
    private weak var view: PlacesViewProtocol?
    private var excursionInfo: InfoExcursion
    private var router: RouterProtocol?
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var location: String?
    
    required init(view: PlacesViewProtocol, info: InfoExcursion, provaider: RestAPIProviderProtocol, router: RouterProtocol, location: String) {
        self.view = view
        self.excursionInfo = info
        self.alamofireProvaider = provaider
        self.router = router
        self.location = location
    }
    
    func tapOnButtonHotels(location: String) {
        router?.showHotelsModule(location: location)
    }
    func tapOnButtonFlights(location: String) {
        router?.showFlightsModule(location: location)
    }
    func tapOnButtonExplore() {
        router?.popToRoot()
    }
    
    func getLocation() {
        guard let location = location else { return }
        view?.setLocation(location: location)
    }
    func clearArray() {
        self.excursionInfo.price.removeAll()
        self.excursionInfo.nameExcursion.removeAll()
        self.excursionInfo.image.removeAll()
    }
    func getArrayPrice() -> [Int] {
       return excursionInfo.price
    }
    func getArrayNameExc() -> [String] {
        return excursionInfo.nameExcursion
    }
    func getArrayImage() -> [UIImage] {
        return excursionInfo.image
    }
    func getCodeByNameCity(code: String) {
        alamofireProvaider.getNameCityByCode(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                // некоторых городов нет в базе, в этом случае  направления будут стандартные
                guard !value.isEmpty else {
                    self.view?.setInfoExc(code:"None")
                    return
                }
                guard let code = value.first?.code else { return }
                self.view?.setInfoExc(code: code)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let firstElement = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let secondElement = dateFormatter.string(from: date)
        return "\(firstElement)T\(secondElement)"
    }
    
    func getPhotoByURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.excursionInfo.image.append(icon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getExcursionInfo(code: String, start: Date, end: Date, adults: String, child: String) {
        let startDate = convertDateToString(date: start)
        let endDate = convertDateToString(date: end)
        alamofireProvaider.getExcursionInfo(codeCity: code, start: startDate, end: endDate, adults: adults, child: child) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                guard let val = value.data, !val.isEmpty else {
                    self.excursionInfo.nameExcursion.append("Sorry! Not found")
                    self.excursionInfo.price.append(0)
                    
                    return }
                for exc in val {
                    guard let nameExc = exc.content, let price = exc.price, let url = exc.photo else { return }
                   // название экскурсий
                    self.getPhotoByURL(url: url)
                    self.excursionInfo.nameExcursion.append(nameExc)
                    self.excursionInfo.price.append(Int(price))
                    print(self.excursionInfo.price)
                    print(self.excursionInfo.nameExcursion)
                    self.view?.updateTableView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

