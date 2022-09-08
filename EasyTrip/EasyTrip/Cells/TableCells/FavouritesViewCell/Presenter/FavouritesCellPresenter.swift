//
//  FavouritesCellPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 8.09.22.
//

import Foundation
import UIKit

protocol FavouritesCellPresenterProtocol {
    func getInfoFavourites(nameFavourites: String, image: UIImage)
}
class FavouritesCellPresenter: FavouritesCellPresenterProtocol {
    
    private weak var view: FavouritesCellProtocol!
    
        required init(view: FavouritesCellProtocol){
            self.view = view
        }
    
    func getInfoFavourites(nameFavourites: String, image: UIImage){
        self.view.fillField(nameFavourites: nameFavourites, image: image)
    }
}
