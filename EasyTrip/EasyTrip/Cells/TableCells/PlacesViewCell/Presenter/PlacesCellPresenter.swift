//
//  PlacesCellPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 8.09.22.
//

import Foundation
import UIKit

protocol PLacesCellPresenterProtocol{
    func fieldCell(image: UIImage, excPrice: String, name: String, urlPlaces: String)
    func getAllFavouritesDocuments(id: String, name: String, url: String)
    func writeFavourites(id: String, dictionary: [String : String])
    func getCurrentUserId()
}

class PlacesCellPresenter: PLacesCellPresenterProtocol {
    private var view: PlacesCellProtocol!
    private var firebaseProvaider: FirebaseProtocol!
    
    required init (view: PlacesCellProtocol, firebase: FirebaseProtocol) {
        self.view = view
        self.firebaseProvaider = firebase
    }
    func fieldCell(image: UIImage, excPrice: String, name: String, urlPlaces: String) {
        self.view.fieldCell(image: image, excPrice: excPrice, name: name, urlPlaces: urlPlaces)
    }
    
    func getCurrentUserId(){
        firebaseProvaider.getCurrentUserId { id in
            guard let id = id else { return }
            self.view.setUserId(id: id)
        }
    }
    
    func getAllFavouritesDocuments(id: String, name: String, url: String){
        firebaseProvaider.getAllFavouritesDocuments(collection: "favouritesPlaces", docName: id) { [weak self] list in
            guard let self = self else { return }
            if list == nil {
                self.writeFavourites(id: id, dictionary: [name : url])
            } else {
                guard var dictionary = list?.favourites else { return }
                dictionary[name] = "\(url)"
                self.writeFavourites(id: id, dictionary: dictionary)
            }
        }
    }
    
    func writeFavourites(id: String, dictionary: [String : String]){
        self.firebaseProvaider.writeFavourites(collection: "favouritesPlaces", docName: id, hotels: dictionary)
    }
}
