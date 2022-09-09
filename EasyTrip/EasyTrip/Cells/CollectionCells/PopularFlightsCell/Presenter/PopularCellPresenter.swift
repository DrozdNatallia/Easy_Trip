//
//  PopularCellPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 8.09.22.
//

import Foundation
import UIKit

protocol PopularCellPresenterProtocol {
    func getInfoPopularCity(name: String, image: UIImage)
}

class PopularCellPresenter: PopularCellPresenterProtocol {
    private weak var view: PopularCellProtocol!
    
    required init (view: PopularCellProtocol){
        self.view = view
    }
    //заполнение полей
    func getInfoPopularCity(name: String, image: UIImage){
        self.view.fillField(name: name, image: image)
    }
}
