//
//  AppDelegate.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 19/08/2020.
//  Copyright © 2020 OlivierConan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: RootCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        coordinator = RootCoordinator(navigationController: navController)
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

}

