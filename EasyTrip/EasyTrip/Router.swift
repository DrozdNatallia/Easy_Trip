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
    func showFlightsModule(location: String)
    func showHotelsModule(location: String)
    func showPlacesModule(location: String)
    func popToRoot()
    func initFavouritesViewControllers()
    func initPersonalViewControllers()
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
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let homeViewController = assemblyBuilder?.createModel(router: self) else { return }
            navigationController.viewControllers = [homeViewController]
            controllers.append(navigationController)
        }

    }
    func initFavouritesViewControllers() {
        guard let favouritesViewController = assemblyBuilder?.createFavouritesModule(router: self) else { return }
        favouritesViewController.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star"), tag: 1)
        controllers.append(favouritesViewController)
    }
    
    func initPersonalViewControllers() {
        guard let personalVc = assemblyBuilder?.createPersonalModule(router: self) else { return }
       personalVc.tabBarItem = UITabBarItem(title: "Perconal account", image: UIImage(systemName: "person"), tag: 2)
        controllers.append(personalVc)
    }
    func showRegistration() {
        if let navigationController = navigationController {
            guard let authVc = assemblyBuilder?.createAuthModule(router: self) else {
                return
            }
            authVc.modalPresentationStyle = .fullScreen
            navigationController.present(authVc, animated: false)
        }
    }
    
    func initialTabBArController() {
        if let tabBarController = tabBarController {
            tabBarController.setViewControllers(controllers, animated: true)
        }
    }
    
    func showFlightsModule(location: String) {
        if let navigationController = navigationController {
            guard let flightsViewController = assemblyBuilder?.createFlightsModule(location: location, router: self) else { return }
            navigationController.pushViewController(flightsViewController, animated: true)
        }
    }
    
    func showHotelsModule(location: String) {
        if let navigationController = navigationController {
            guard let hotelsViewController = assemblyBuilder?.createHotelsModule(location: location, router: self) else { return }
            navigationController.pushViewController(hotelsViewController, animated: true)
        }
    }
    
    func showPlacesModule(location: String) {
        if let navigationController = navigationController {
            guard let placesViewController = assemblyBuilder?.createPlacesModule(location: location, router: self) else { return }
            navigationController.pushViewController(placesViewController, animated: true)
        }
    }
    func popToRoot(){
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
