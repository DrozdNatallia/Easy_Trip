//
//  Presenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 13.08.22.
//

import Foundation
import UIKit
import Alamofire

protocol HomeViewPresenterProtocol {
    func getImagebyURL(url: String)
    func getNamePopularCityByCode(code: String, isName: Bool)
    func getPopularFlights(nameDirection: String)
    func getArrayNameCity() -> [String]
    func clearArrays()
    func tapOnButton(location: String, icon: UIImage?)
    func tapOnButtonHotels(location: String, icon: UIImage)
    func tapOnButtonPlaces(location: String, icon: UIImage)
    func addImageFromStorage()
    func configure(cell: PopularCellProtocol, row: Int) 
}

final class HomeViewPresenter: HomeViewPresenterProtocol {
    private weak var view: HomeViewProtocol?
    private var popularCityInfo: PopulareCityDate
    private var router: RouterProtocol?
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var firebaseProvaider: FirebaseProtocol!
    required init(view: HomeViewProtocol, info: PopulareCityDate, provaider: RestAPIProviderProtocol, router: RouterProtocol, firebase: FirebaseProtocol) {
        self.view = view
        self.popularCityInfo = info
        self.alamofireProvaider = provaider
        self.router = router
        self.firebaseProvaider = firebase
    }
    // Добаыление иконки пользователя из storage
    func addImageFromStorage() {
        firebaseProvaider.getCurrentUserId { [weak self] id in
            guard let self = self else {return}
            guard let id = id else { return }
            self.firebaseProvaider.getInfoUser(collection: "User", userId: id) { [weak self] user in
                guard let self = self, let user = user, let url = user.url else { return }
                self.firebaseProvaider.getIMageFromStorage(url: url) { [weak self]image in
                    guard let self = self, let image = image else { return }
                    self.view?.updateIcon(image: image)
                }
            }
        }
    }
    
    func configure(cell: PopularCellProtocol, row: Int) {
        let nameDirection = popularCityInfo.arrayNameCity[row]
        let iconDirection = popularCityInfo.arrayImageCity[row]
        cell.fillField(name: nameDirection, image: iconDirection)
    }
    // переход на FlightsViewController
    func tapOnButton(location: String, icon: UIImage?) {
        router?.showFlightsModule(location: location, icon: icon )
    }
    //переход на HotelsViewController
    func tapOnButtonHotels(location: String, icon: UIImage) {
        router?.showHotelsModule(location: location, icon: icon)
    }
    // переход на PlacesViewController
    func tapOnButtonPlaces(location: String, icon: UIImage) {
        router?.showPlacesModule(location: location, icon: icon)
    }
    // получение имен городов
    func getArrayNameCity() -> [String] {
        return popularCityInfo.arrayNameCity
    }
    // чистка всех массивов 
    func clearArrays() {
        popularCityInfo.arrayImageCity.removeAll()
        popularCityInfo.arrayNameCity.removeAll()
    }
    
    // получение картинки по URL
  func getImagebyURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.popularCityInfo.arrayImageCity.append(icon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
   // функция конвертит IATA код в полное имя, и наооборот
    func getNamePopularCityByCode(code: String, isName: Bool) {
        alamofireProvaider.getNameCityByCode(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                // некоторых городов нет в базе, в этом случае  направления будут стандартные
                guard !value.isEmpty else {
                    self.view?.setPopularFlights(city: "None", isName: false)
                    return
                }
                guard let name = value.first?.name, let code = value.first?.code else { return }
                // если код/имя страны найдено, то добавдяем значение которое нам надо в массив
                if isName {
                    self.popularCityInfo.arrayNameCity.append(name)
                    self.view?.setPopularFlights(city: name, isName: isName)
                } else {
                    self.view?.setPopularFlights(city: code, isName: isName)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getPopularFlights(nameDirection: String) {
        // чистим массив картинок
        alamofireProvaider.getPopularFlights(country: nameDirection) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                // есть страны, из которыз направления не найдены, тогда date будет пустым массивом, в этом случае будет установлена картинка и надпись об ошибке
                guard let date = value.data, !date.isEmpty else {
                    guard let image = UIImage(named: "error2.jpeg") else { return }
                    self.popularCityInfo.arrayImageCity.append(image)
                    self.popularCityInfo.arrayNameCity.append("Sorry! Directions not found.")
                    self.view?.setPopularFlights(city: "Sorry! Directions not found.", isName: true)
                    return}
                for flight in date.values {
                    // код страны прибытия
                    guard let destination = flight.destination else { return }
                    // картинки по url получаем
                    let width = self.popularCityInfo.sizeImage
                    let url = Constants.getImageCityByURL.appending("\(width)x250/\(destination).jpg")
                    self.getImagebyURL(url: url)
                    // вызываем функцию и полученный код передаем
                    self.getNamePopularCityByCode(code: destination, isName: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


