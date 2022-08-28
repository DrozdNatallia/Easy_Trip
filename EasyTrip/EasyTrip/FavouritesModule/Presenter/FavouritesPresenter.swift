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
    func getArrayNameHotels() -> [String]
    func getArrayImage() -> [UIImage]
    
}

final class FavouritesViewPresenter: FavouritesViewPresenterProtocol {
    private weak var view: FavouritesViewProtocol?
    private var favourites: Hotels
    private var router: RouterProtocol?
    private var firebaseProvaider: FirebaseProtocol!
    
    required init(view: FavouritesViewProtocol, info: Hotels, provaider: FirebaseProtocol, router: RouterProtocol) {
        self.view = view
        self.favourites = info
        self.firebaseProvaider = provaider
        self.router = router
    }
    func getArrayImage() -> [UIImage] {
         favourites.imageHotel
    }
    
    func getArrayNameHotels() -> [String] {
        favourites.nameHotel
    }
    

    func getAllDocument(collection: String) {
        firebaseProvaider.getAllDocuments(collection: collection) { list in
            for list in list {
                guard let name = list?.name, let url = list?.url else { return }
                self.favourites.nameHotel.append(name)
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
                  self.favourites.imageHotel.append(icon)
              } catch let error {
                  print(error.localizedDescription)
              }
          }
    }
    
    
}

