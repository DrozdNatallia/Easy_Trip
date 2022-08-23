//
//  PlacesPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 23.08.22.
//

import UIKit
protocol PlacesViewPresenterProtocol {
    func getExcursionInfo(code: String)
    func getArrayNameExc() -> [String]
    func getArrayPrice() -> [Int]
}

final class PlacesViewPresenter: PlacesViewPresenterProtocol {
    private weak var view: PlacesViewProtocol?
    private var excursionInfo: InfoExcursion
    private var router: RouterProtocol?
    private var alamofireProvaider: RestAPIProviderProtocol!
    private var location: String?
    
    required init(view: PlacesViewProtocol, info: InfoExcursion, provaider: RestAPIProviderProtocol, router: RouterProtocol, location: String) {
        self.view = view
        self.excursionInfo = info
        self.alamofireProvaider = provaider
        self.router = router
        self.location = location
    }
    
//    func tapOnButton(location: String) {
//        router?.showFlightsModule(location: location )
//    }
//    func tapOnButtonHotels(location: String) {
//        router?.showHotelsModule(location: location)
//    }
    
    func getArrayPrice() -> [Int] {
       return excursionInfo.price
    }
    func getArrayNameExc() -> [String] {
        return excursionInfo.nameExcursion
    }
    func getExcursionInfo(code: String) {
        alamofireProvaider.getExcursionInfo(codeCity: "LON") { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                guard let val = value.data else {return}
                for exc in val {
                    guard let nameExc = exc.content, let price = exc.price else { return }
                   // название экскурсий
                    self.excursionInfo.nameExcursion.append(nameExc)
                    self.excursionInfo.price.append(price)
                    print(self.excursionInfo.price)
                    print(self.excursionInfo.nameExcursion)
                    self.view?.updateTableView()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

