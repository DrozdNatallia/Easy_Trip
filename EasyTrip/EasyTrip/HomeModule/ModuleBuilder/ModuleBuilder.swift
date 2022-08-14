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
}

