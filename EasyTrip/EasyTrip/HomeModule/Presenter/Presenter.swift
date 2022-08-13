//
//  Presenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 13.08.22.
//

import Foundation
import UIKit
import Alamofire

final class HomeViewPresenter: HomeViewPresenterProtocol {
    
    private weak var view: HomeViewProtocol?
    var popularCityInfo: PopulareCityDate
    var alamofireProvaider = AlamofireProvaider()
    
    required init(view: HomeViewProtocol, info: PopulareCityDate) {
        self.view = view
        self.popularCityInfo = info
    }
    // получение картинки по URL
    func getImagebyURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.popularCityInfo.arrayImageCity.append(icon)
                //пердаем массив во VC
                self.view?.setImageCity(image: self.popularCityInfo.arrayImageCity)
            } catch _ {
                print("error")
            }
        }
    }
    
    func getNamePopularCityByCode(code: String, isName: Bool) {
        // чистим старый массив с именами стран
        self.popularCityInfo.arrayNameCity.removeAll()
        alamofireProvaider.getNameCityByCode(code: code) { result in
            switch result {
            case .success(let value):
                // некоторых городов нет в базе, в этом случае  направления будут стандартные
                guard !value.isEmpty else {
                    self.popularCityInfo.arrayNameCity.append(isName ? "SanFrancisco" : "SFO")
                    // передаем массив имен
                    self.view?.getNamePopularCityByCode(city: self.popularCityInfo.arrayNameCity, isName: isName)
                    return
                }
                guard let name = value.first?.name, let code = value.first?.code else { return }
                // если код/имя страны найдено, то добавдяем значение которое нам надо в массив
                self.popularCityInfo.arrayNameCity.append(isName ? name : code)
                self.view?.getNamePopularCityByCode(city: self.popularCityInfo.arrayNameCity, isName: isName)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getPopularFlights(nameDirection: String) {
        // чистим массив картинок
        self.popularCityInfo.arrayImageCity.removeAll()
        alamofireProvaider.getPopularFlights(country: nameDirection) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                // есть страны, из которыз направления не найдены, тогда date будет пустым массивом, в этом случае будет установлена картинка и надпись об ошибке
                guard let date = value.data, !date.isEmpty else {
                    guard let image = UIImage(named: "error2.jpeg") else { return }
                    self.popularCityInfo.arrayNameCity.removeAll()
                    self.popularCityInfo.arrayImageCity.append(image)
                    self.view?.setImageCity(image: self.popularCityInfo.arrayImageCity)
                    self.popularCityInfo.arrayNameCity.append("Sorry! Directions not found.")
                    self.view?.getNamePopularCityByCode(city: self.popularCityInfo.arrayNameCity, isName: true)
                    return}
                for flight in date.values {
                    // код страны прибытия
                    guard let destination = flight.destination, let width = self.popularCityInfo.sizeImage else { return }
                    // картинки по url получаем
                    let url = Constants.getImageCityByURL + "\(width)x250/" + "\(destination).jpg"
                    self.getImagebyURL(url: url)
                    // полученный код передаем во VC
                    self.view?.getPopularFlights(code: destination)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


