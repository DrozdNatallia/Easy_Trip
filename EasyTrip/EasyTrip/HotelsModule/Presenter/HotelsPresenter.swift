//
//  HotelsPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import Foundation
import UIKit

import UIKit
protocol HotelsViewPresenterProtocol: AnyObject {
    func getHotelsByCityName(name: String, checkIn: String, checkOut: String, adults: Int)
    func getArrayNameHotel() -> [String]
    func getPhotoByURL(url: String)
    func getArrayImages() -> [UIImage]
    func getArrayUrl() -> [String]
    func clearArray()
    func getLocation()
    func tapOnButtonFlights(location: String, icon: UIImage)
    func tapOnButtonPlaces(location: String, icon: UIImage)
    func tapOnButtonExplore()
    func getIconImage()
    func configure(cell: HotelsCellProtocol, section: Int)
    func getFavouritesHotels(id: String, name: String, url: String)
    func writeFavouritesHotel(id: String, dictionary: [String : String])
    func getIdUser(completion: @escaping (String?) -> Void)
}


final class HotelsViewPresenter: HotelsViewPresenterProtocol {
  
    private weak var view: HotelsViewProtocol?
    private var infoHotels: InfoHotel
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var firebaseProvaider: FirebaseProtocol!
    private var router: RouterProtocol?
    private var location: String?
    var icon: UIImage?
    
    required init(view: HotelsViewProtocol, info: InfoHotel, provaider: RestAPIProviderProtocol, location: String, router: RouterProtocol, icon: UIImage?, firebase: FirebaseProtocol) {
        self.view = view
        self.infoHotels = info
        self.alamofireProvaider = provaider
        self.router = router
        self.location = location
        self.icon = icon
        self.firebaseProvaider = firebase
    }
    // получение иконки пользователя
    func getIconImage() {
        guard let image = icon else {return}
        self.view?.addIconImage(image: image)
    }
    // получение локации
    func getLocation() {
        guard let location = location else { return }
        view?.setLocation(location: location)
    }
    // чистка всех массивов
    func clearArray() {
        infoHotels.arrayImages.removeAll()
        infoHotels.arrayNameHotel.removeAll()
        infoHotels.url.removeAll()
    }
    // получение массивов с названиями отелей
    func getArrayNameHotel() -> [String] {
        return infoHotels.arrayNameHotel
    }
    // получение массива с картинками
    func getArrayImages() -> [UIImage] {
        infoHotels.arrayImages
    }
    // получение массиврв урлов
    func getArrayUrl() -> [String] {
        infoHotels.url
    }
    // переход на placesViewController
    func tapOnButtonPlaces(location: String, icon: UIImage) {
        router?.showPlacesModule(location: location, icon: icon)
    }
    // переход на FlightsViewController
    func tapOnButtonFlights(location: String, icon: UIImage) {
        router?.showFlightsModule(location: location, icon: icon)
    }
    // возвращение на HomeViewController
    func tapOnButtonExplore() {
        router?.popToRoot()
    }
    
    func configure(cell: HotelsCellProtocol, section: Int) {
        let nameHotels = infoHotels.arrayNameHotel[section]
        let iconHotels = infoHotels.arrayImages[section]
        let url = infoHotels.url[section]
        cell.fillField(name: nameHotels, image: iconHotels, hotelsUrl: url)
    }
    func getIdUser(completion: @escaping (String?) -> Void){
        firebaseProvaider.getCurrentUserId { id in
            guard let id = id else { return }
            completion(id)
        }
    }
    
    // получение списка избранных отелей
    func getFavouritesHotels(id: String, name: String, url: String){
        firebaseProvaider.getAllFavouritesDocuments(collection: "favouritesHotels", docName: id) { [weak self] list in
            guard let self = self else { return }
            if list == nil {
                self.writeFavouritesHotel(id: id, dictionary: [name : url])
                self.view?.showAlertWithMassage()
            } else {
                guard var dictionary = list?.favourites else { return }
                dictionary[name] = "\(url)"
                self.writeFavouritesHotel(id: id, dictionary: dictionary)
                self.view?.showAlertWithMassage()
            }
        }
    }
    
    func writeFavouritesHotel(id: String, dictionary: [String : String]) {
        firebaseProvaider.writeFavourites(collection: "favouritesHotels", docName: id, hotels: dictionary)
    }

    // получение картинки по url
    func getPhotoByURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.infoHotels.arrayImages.append(icon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    // получение отелей по имени города
    func getHotelsByCityName(name: String, checkIn: String, checkOut: String, adults: Int ) {
        alamofireProvaider.getHoltelsByCityName(name: name, chekIn: checkIn, checkOut: checkOut, adults: adults) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                for hotel in value {
                    guard let nameHotel = hotel.hotelName, let idHotel = hotel.hotelID else { return }
                    self.infoHotels.arrayNameHotel.append(nameHotel)
                    let url = Constants.getPhotoHotels.appending("\(idHotel)_1/180/200.auto")
                    self.infoHotels.url.append(url)
                    self.getPhotoByURL(url: url)
                    self.view?.updateCollectionView()
                }
            case .failure(let error):
                self.view?.stopAnimation()
                print(error.localizedDescription)
            }
        }
    }
}

