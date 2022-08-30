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
    func getAllDocument(collection: String)
    func getImagebyURLFavourites(url: String)
    func getArrayName() -> [String]
    func getArrayImage() -> [UIImage]
    func clearArray()
    
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
    
// получение всех документов по имени коллекции
    func getAllDocument(collection: String) {
        firebaseProvaider.getAllDocuments(collection: collection) { list in
            for list in list {
                guard let name = list?.name, let url = list?.url else { return }
                self.favourites.name.append(name)
                self.getImagebyURLFavourites(url: url)
                self.view?.updateTable()
            }
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
    
    
}

