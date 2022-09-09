//
//  FlightsCellPresenter.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 8.09.22.
//

import Foundation
import UIKit

protocol FlightsCellPresenterProtocol{
    func getInfoFlight(originCity: String, destinationCity: String, priceFlights: String, transferFlight: String, flightTime: String, icon: UIImage, depart: String  )
}

class FlightsCellPresenter: FlightsCellPresenterProtocol {
    private weak var view: FlightsCellProtocol!
    
    required init(view: FlightsCellProtocol){
        self.view = view
    }
    func getInfoFlight(originCity: String, destinationCity: String, priceFlights: String, transferFlight: String, flightTime: String, icon: UIImage, depart: String ) {
        self.view.fillField(originCity: originCity, destinationCity: destinationCity, priceFlights: priceFlights, transferFlight: transferFlight, flightTime: flightTime, icon: icon, depart: depart)
    }
}
