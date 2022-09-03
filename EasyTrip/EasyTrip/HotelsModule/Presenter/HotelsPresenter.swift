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
    func tapOnButtonFlights(location: String)
    func tapOnButtonPlaces(location: String)
    func tapOnButtonExplore()
}


class HotelsViewPresenter: HotelsViewPresenterProtocol {
    
    private weak var view: HotelsViewProtocol?
    private var infoHotels: InfoHotel
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var router: RouterProtocol?
    private var location: String?
    
    required init(view: HotelsViewProtocol, info: InfoHotel, provaider: RestAPIProviderProtocol, location: String, router: RouterProtocol) {
        self.view = view
        self.infoHotels = info
        self.alamofireProvaider = provaider
        self.router = router
        self.location = location
    }
    
    func getLocation() {
        guard let location = location else { return }
        view?.setLocation(location: location)
    }
    
    func clearArray() {
        infoHotels.arrayImages.removeAll()
        infoHotels.arrayNameHotel.removeAll()
    }
    func getArrayNameHotel() -> [String] {
        infoHotels.arrayNameHotel
    }
    func getArrayImages() -> [UIImage] {
        infoHotels.arrayImages
    }
    func getArrayUrl() -> [String] {
        infoHotels.url
    }
    
    func tapOnButtonPlaces(location: String) {
        router?.showPlacesModule(location: location)
    }
    
    func tapOnButtonFlights(location: String) {
        router?.showFlightsModule(location: location)
    }
    func tapOnButtonExplore() {
        router?.popToRoot()
    }
    
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
                print(error.localizedDescription)
            }
        }
    }
}

