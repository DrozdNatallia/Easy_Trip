//
//  Router.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 20.08.22.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AsselderBuildProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showFlightsModule(location: String)
    func showHotelsModule(location: String)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AsselderBuildProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AsselderBuildProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let homeViewController = assemblyBuilder?.createModel(router: self) else { return }
            navigationController.viewControllers = [homeViewController]
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
    func popToRoot(){
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
