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
    func getArrayUrl() -> [String]
    func clearArray()
    func tapOnButtonHotels(location: String, icon: UIImage)
    func tapOnButtonFlights(location: String, icon: UIImage)
    func tapOnButtonExplore()
    func addIconImage()
    func getLocation()
}

final class PlacesViewPresenter: PlacesViewPresenterProtocol {
    private weak var view: PlacesViewProtocol?
    private var excursionInfo: InfoExcursion
    private var router: RouterProtocol?
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var location: String?
    private var firebaseProvaider: FirebaseProtocol!
    var icon: UIImage?
    
    required init(view: PlacesViewProtocol, info: InfoExcursion, provaider: RestAPIProviderProtocol, router: RouterProtocol, location: String, firebase: FirebaseProtocol, icon: UIImage?) {
        self.view = view
        self.excursionInfo = info
        self.alamofireProvaider = provaider
        self.router = router
        self.location = location
        self.firebaseProvaider = firebase
        self.icon = icon
    }
    // получение иконки пользователя
    func addIconImage() {
        guard let image = icon else {return}
        self.view?.setIconImage(image: image)
    }
    // переходы
    func tapOnButtonHotels(location: String, icon: UIImage) {
        router?.showHotelsModule(location: location, icon: icon)
    }
    func tapOnButtonFlights(location: String, icon: UIImage) {
        router?.showFlightsModule(location: location, icon: icon)
    }
    func tapOnButtonExplore() {
        router?.popToRoot()
    }
    // получкние локации
    func getLocation() {
        guard let location = location else { return }
        view?.setLocation(location: location)
    }
    // чистка вскх массивов
    func clearArray() {
        self.excursionInfo.price.removeAll()
        self.excursionInfo.nameExcursion.removeAll()
        self.excursionInfo.image.removeAll()
        self.excursionInfo.url.removeAll()
    }
    // получение инфоромации из массивов
    func getArrayPrice() -> [Int] {
       return excursionInfo.price
    }
    func getArrayNameExc() -> [String] {
        return excursionInfo.nameExcursion
    }
    func getArrayImage() -> [UIImage] {
        return excursionInfo.image
    }
    func getArrayUrl() -> [String] {
        return excursionInfo.url
    }
    // получение кода для получения информации об экскурсиях
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
                self.view?.stopAnimation()
                print(error.localizedDescription)
            }
        }
    }
    //конвертация дат
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    // фото по урл
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
    // получение инфы об экскурсиях
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
                    self.excursionInfo.url.append(url)
                    self.getPhotoByURL(url: url)
                    self.excursionInfo.nameExcursion.append(nameExc)
                    self.excursionInfo.price.append(Int(price))
                    self.view?.updateTableView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

