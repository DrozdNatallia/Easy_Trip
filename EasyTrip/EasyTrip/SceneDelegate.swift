//
//  SceneDelegate.swift
//  EasyTrip
//
//  Created by Natalia Drozd on 9.08.22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        if let window = window {
            let navigationController = UINavigationController()
            let tabBar = UITabBarController()
            let assemblyBuilder = HomeBuilderClass()
            let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder, tabBar: tabBar)
            let defaults = UserDefaults()
            router.initialViewController()
            router.initFavouritesViewControllers()
            router.initPersonalViewControllers()
            router.initialTabBArController()
            window.rootViewController = tabBar
            navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            tabBar.tabBar.backgroundColor = .secondarySystemBackground
            tabBar.tabBar.tintColor = .systemBlue
            window.makeKeyAndVisible()
            Auth.auth().addStateDidChangeListener { auth, user in
                var newUser = user
                if !defaults.bool(forKey: "isAppAlreadyLaunchedOnce") {
                    newUser = nil
                }
                if newUser == nil {
                    UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
                    router.showRegistration()
                }
            }
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

