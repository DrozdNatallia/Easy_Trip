//
//  HomeBuilder.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 13.08.22.
//

import Foundation
import UIKit

protocol Builder {
    static func createModel() -> UIViewController
    static func createFlightsModule() -> UIViewController
}

class HomeBuilderClass: Builder {
    static func createModel() -> UIViewController {
        
        if  let viewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            let size = Int(viewContoller.view.frame.width)
            let provaider = AlamofireProvaider()
            let info = PopulareCityDate(arrayNameCity: [], arrayImageCity: [], sizeImage: size)
            let presenter = HomeViewPresenter(view: viewContoller, info: info, provaider: provaider)
            viewContoller.presenter = presenter
            return viewContoller
        }
        return UIViewController()
    }
    
    static func createFlightsModule() -> UIViewController {
        let vc = FlightsViewController(nibName: "FlightsViewController", bundle: nil)
        let provaider = AlamofireProvaider()
        let info = InfoFlight(arrayPrice: [], arrayDepart: [], arrayArrive: [], arrayTransfer: [], arrayOrigin: [], arrayDestination: [], arrayDuration: [], iconAirlines: [])
        let presenter = FlightsViewPresenter(view: vc, info: info, provaider: provaider)
        vc.presenter = presenter
        return vc
    }
}

