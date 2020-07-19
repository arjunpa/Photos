//
//  AppDelegate.swift
//  Photos
//
//  Created by Arjun P A on 18/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = PhotoListViewController(with: PhotoListViewModel(with: PhotoListRepository(with: APIService(session: URLSession.shared))))
        self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window?.makeKeyAndVisible()
        return true
    }
}

