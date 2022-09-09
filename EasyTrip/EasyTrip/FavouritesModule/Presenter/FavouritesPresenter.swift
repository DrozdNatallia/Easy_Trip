//
//  FavouritesPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 28.08.22.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

protocol FavouritesViewPresenterProtocol {
    func getImagebyURLFavourites(url: String)
    func deleteDocument(collection: String, name: String)
    func deleteElementFromArray(num: Int)
    func getArrayName() -> [String]
    func getArrayImage() -> [UIImage]
    func clearArray()
    func getCurrentUserId(completion: @escaping (String?) -> Void)
    func getAllFavouritesDocument(collection: String, docName: String)
    func deleteElementFromFavourites(collection: String, docName: String, key: String)
}

final class FavouritesViewPresenter: FavouritesViewPresenterProtocol {
    private weak var view: FavouritesViewProtocol?
    private var favourites: Favourites
    private var router: RouterProtocol?
    private var firebaseProvaider: FirebaseProtocol!
    
    required init(view: FavouritesViewProtocol, info: Favourites, provaider: FirebaseProtocol, router: RouterProtocol) {
        self.view = view
        self.favourites = info
        self.firebaseProvaider = provaider
        self.router = router
    }
    // получение массивов
    func getArrayImage() -> [UIImage] {
        favourites.image
    }
    
    func getArrayName() -> [String] {
        favourites.name
    }
    func clearArray() {
        favourites.image.removeAll()
        favourites.name.removeAll()
    }
    // удаление элемента, используетмя при удалении по свайпу
    func deleteElementFromArray(num: Int) {
        favourites.name.remove(at: num)
        favourites.image.remove(at: num)
    }
    // получение избранного
    func getAllFavouritesDocument(collection: String, docName: String) {
        firebaseProvaider.getAllFavouritesDocuments(collection: collection, docName: docName) { [weak self] places in
            guard let self = self, let places = places, !places.favourites.isEmpty else {
                self?.view?.stopAnimation()
                self?.view?.updateTable()
                return }
            DispatchQueue.global(qos: .userInteractive).async {
                let favouritesPlaces = places.favourites
                for (key, value) in favouritesPlaces {
                    self.favourites.name.append(key)
                    self.getImagebyURLFavourites(url: value)
                    DispatchQueue.main.sync {
                        self.view?.updateTable()
                    }
                }
            }
        }
    }
    // удаление тз базы данных
    func deleteElementFromFavourites(collection: String, docName: String, key: String){
        firebaseProvaider.getAllFavouritesDocuments(collection: collection, docName: docName) { [weak self] favourites in
            guard let self = self, let places = favourites else { return }
            var favourites = places.favourites
            favourites.removeValue(forKey: key)
            self.firebaseProvaider.writeFavourites(collection: collection, docName: docName, hotels: favourites)
            
        }
    }
    func getImagebyURLFavourites(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.favourites.image.append(icon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    // удалить весть документ
    func deleteDocument(collection: String, name: String){
        firebaseProvaider.deleteDocument(collection: collection, nameDoc: name)
    }
    // получить id usera
    func getCurrentUserId(completion: @escaping (String?) -> Void) {
        firebaseProvaider.getCurrentUserId { id in
            if id != nil {
                completion(id)
            } else {
                completion(nil)
            }
        }
    }
}

