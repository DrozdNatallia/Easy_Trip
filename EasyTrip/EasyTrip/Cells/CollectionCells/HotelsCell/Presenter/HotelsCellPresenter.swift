//
//  HotelsCellPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 8.09.22.
//

import Foundation
import UIKit

protocol HotelsCellPresenterProtocol {
    func getInfoHotels(name: String, image: UIImage, url: String)
    func getFavouritesHotels(id: String, name: String, url: String)
    func writeFavouritesHotel(id: String, dictionary: [String : String])
    func getIdUser()
}

class HotelsCellPresenter: HotelsCellPresenterProtocol {
    private weak var view: HotelsCellProtocol!
    private var firebaseProvaider: FirebaseProtocol!
    
    required init(view: HotelsCellProtocol, firebase: FirebaseProtocol){
        self.view = view
        self.firebaseProvaider = firebase
    }
    // получение номера пользователя
    func getIdUser(){
        firebaseProvaider.getCurrentUserId { id in
            guard let id = id else { return }
            self.view.setIdUser(id: id)
        }
    }
    // получение инфы об отелях для заполнения
    func getInfoHotels(name: String, image: UIImage, url: String){
        self.view.fillField(name: name, image: image, hotelsUrl: url)
    }
    // получение списка избранных отелей
    func getFavouritesHotels(id: String, name: String, url: String){
        firebaseProvaider.getAllFavouritesDocuments(collection: "favouritesHotels", docName: id) { [weak self] list in
            guard let self = self else { return }
            if list == nil {
                self.writeFavouritesHotel(id: id, dictionary: [name : url])
            } else {
                guard var dictionary = list?.favourites else { return }
                dictionary[name] = "\(url)"
                self.writeFavouritesHotel(id: id, dictionary: dictionary)
            }
        }
    }
    
    func writeFavouritesHotel(id: String, dictionary: [String : String]) {
        firebaseProvaider.writeFavourites(collection: "favouritesHotels", docName: id, hotels: dictionary)
    }
}
