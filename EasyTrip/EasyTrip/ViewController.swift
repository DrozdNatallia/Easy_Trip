//
//  ViewController.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
var alamofireProvaider = AlamofireProvaider()
    override func viewDidLoad() {
        super.viewDidLoad()
        getPopularFlights()
    }


    fileprivate func getPopularFlights() {
        alamofireProvaider.getPopularFlights(country: "MOW") { [weak self] result in
          //  guard let self = self else { return }
            switch result {
            case .success(let value):
                guard let date = value.data else {return}
                for flight in date.values {
                    print(flight.destination)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

