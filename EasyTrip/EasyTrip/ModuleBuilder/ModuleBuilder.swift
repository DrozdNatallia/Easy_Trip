//
//  HomeBuilder.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 13.08.22.
//

import Foundation
import UIKit

protocol AsselderBuildProtocol {
    func createModel(router: RouterProtocol) -> UIViewController
    func createFlightsModule(location: String, image: UIImage?, router: RouterProtocol) -> UIViewController
    func createHotelsModule(location: String, image: UIImage?, router: RouterProtocol) -> UIViewController
    func createPlacesModule(location: String, image: UIImage?, router: RouterProtocol) -> UIViewController
    func createFavouritesModule(router: RouterProtocol ) -> UIViewController
    func createAuthModule(router: RouterProtocol) -> UIViewController
    func createPersonalModule(router: RouterProtocol) -> UIViewController 
}

class HomeBuilderClass: AsselderBuildProtocol {
    func createModel(router: RouterProtocol) -> UIViewController {
        if  let viewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            let size = Int(viewContoller.view.frame.width)
            let provaider = AlamofireProvaider()
            let info = PopulareCityDate(size: size)
            let firebaseProvaider = FirebaseManager()
            let presenter = HomeViewPresenter(view: viewContoller, info: info, provaider: provaider, router: router, firebase: firebaseProvaider)
            viewContoller.presenter = presenter
            return viewContoller
        }
        return UIViewController()
    }
    
    func createFlightsModule(location: String, image: UIImage?, router: RouterProtocol) -> UIViewController {
        let vc = FlightsViewController(nibName: "FlightsViewController", bundle: nil)
        let provaider = AlamofireProvaider()
        let info = InfoFlight()
        let presenter = FlightsViewPresenter(view: vc, info: info, provaider: provaider, router: router, location: location, icon: image)
        vc.presenter = presenter
        return vc
    }
    
    func createHotelsModule(location: String, image: UIImage?, router: RouterProtocol ) -> UIViewController {
        let vc = HotelsViewController(nibName: "HotelsViewController", bundle: nil)
        let provaider = AlamofireProvaider()
        let info = InfoHotel()
        let presenter = HotelsViewPresenter(view: vc, info: info, provaider: provaider, location: location, router : router, icon: image)
        vc.presenter = presenter
        return vc
    }
    
    func createPlacesModule(location: String, image: UIImage?, router: RouterProtocol ) -> UIViewController {
        let vc = PlacesViewController(nibName: "PlacesViewController", bundle: nil)
        let provaider = AlamofireProvaider()
        let info = InfoExcursion()
        let firebase = FirebaseManager()
        let presenter = PlacesViewPresenter(view: vc, info: info, provaider: provaider, router: router, location: location, firebase: firebase, icon: image)
        vc.presenter = presenter
        return vc
    }
    
    func createFavouritesModule(router: RouterProtocol ) -> UIViewController {
        let vc = FavouritesViewController(nibName: "FavouritesViewController", bundle: nil)
        let provaider = FirebaseManager()
        let info = Favourites()
        let presenter = FavouritesViewPresenter(view: vc, info: info, provaider: provaider, router: router)
        vc.presenter = presenter
        return vc
    }
    func createAuthModule(router: RouterProtocol) -> UIViewController {
        let vc = AuthViewController(nibName: "AuthViewController", bundle: nil)
        let provaider = FirebaseManager()
        let presenter = AuthPresenter(view: vc, provaider: provaider, router: router)
        vc.presenter = presenter
        return vc
    }
    
    func createPersonalModule(router: RouterProtocol) -> UIViewController {
        let vc = PersonalViewController(nibName: "PersonalViewController", bundle: nil)
        let provaider = FirebaseManager()
        let presenter = PersonalPresenter(view: vc, provaider: provaider, router: router)
        vc.presenter = presenter
        return vc
    }
}

