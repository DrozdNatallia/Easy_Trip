//
//  Router.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var tabBarController: UITabBarController? {get set}
    var assemblyBuilder: AsselderBuildProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func initialTabBArController()
    func showRegistration()
    func showFlightsModule(location: String, icon: UIImage?)
    func showHotelsModule(location: String, icon: UIImage?)
    func showPlacesModule(location: String, icon: UIImage?)
    func popToRoot()
    func initFavouritesViewControllers()
    func initPersonalViewControllers()
    func clearControllers()
}

class Router: RouterProtocol {
    var tabBarController: UITabBarController?
    var navigationController: UINavigationController?
    var assemblyBuilder: AsselderBuildProtocol?
    var controllers: [UIViewController]
    
    init(navigationController: UINavigationController, assemblyBuilder: AsselderBuildProtocol, tabBar: UITabBarController, controllers: [UIViewController] = []) {
        self .tabBarController = tabBar
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.controllers = controllers
    }
    
    // homeViewController
    func initialViewController() {
        if let navigationController = navigationController {
            guard let homeViewController = assemblyBuilder?.createModel(router: self) else { return }
            navigationController.viewControllers = [homeViewController]
            controllers.append(navigationController)
        }

    }
    // FavouritesViewController
    func initFavouritesViewControllers() {
        guard let favouritesViewController = assemblyBuilder?.createFavouritesModule(router: self) else { return }
        favouritesViewController.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star"), tag: 1)
        controllers.append(favouritesViewController)
    }
    
    func clearControllers(){
        controllers.removeAll()
    }
    
    // PersonalViewCintroller
    func initPersonalViewControllers() {
        guard let personalVc = assemblyBuilder?.createPersonalModule(router: self) else { return }
       personalVc.tabBarItem = UITabBarItem(title: "Perconal account", image: UIImage(systemName: "person"), tag: 2)
        controllers.append(personalVc)
    }
    // AuthViewConroller
    func showRegistration() {
        if let navigationController = navigationController {
            guard let authVc = assemblyBuilder?.createAuthModule(router: self) else {
                return
            }
            authVc.modalPresentationStyle = .fullScreen
            navigationController.present(authVc, animated: false)
        }
    }
    // инициализация tabbar
    func initialTabBArController() {
        if let tabBarController = tabBarController {
            tabBarController.setViewControllers(controllers, animated: true)
        }
    }
    // FlightsViewController
    func showFlightsModule(location: String, icon: UIImage?) {
        if let navigationController = navigationController {
            guard let flightsViewController = assemblyBuilder?.createFlightsModule(location: location, image: icon, router: self) else { return }
            navigationController.pushViewController(flightsViewController, animated: true)
        }
    }
    // HotelsViewController
    func showHotelsModule(location: String, icon: UIImage?) {
        if let navigationController = navigationController {
            guard let hotelsViewController = assemblyBuilder?.createHotelsModule(location: location, image: icon, router: self) else { return }
            navigationController.pushViewController(hotelsViewController, animated: true)
        }
    }
    // PlacesViewController
    func showPlacesModule(location: String, icon: UIImage?) {
        if let navigationController = navigationController {
            guard let placesViewController = assemblyBuilder?.createPlacesModule(location: location, image: icon, router: self) else { return }
            navigationController.pushViewController(placesViewController, animated: true)
        }
    }
    // Возвращение на homeViewController
    func popToRoot(){
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
