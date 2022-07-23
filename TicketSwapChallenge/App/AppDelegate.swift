//
//  AppDelegate.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 14/07/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //lazy var rootViewController = ViewController()
    let homeViewController = HomeViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSigned {
            window?.rootViewController = navigationController
        } else {
            let navController = UINavigationController(rootViewController: WelcomeViewController())
            navController.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            navController.navigationBar.prefersLargeTitles = true
            window?.rootViewController = navController
        }
        window?.makeKeyAndVisible()
        AuthManager.shared.refreshAccessToken { status in
            print(status)
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //rootViewController.sessionManager!.application(app, open: url, options: options)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
//         if (rootViewController.appRemote.isConnected) {
//            rootViewController.appRemote.disconnect()
//        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
//            rootViewController.appRemote.connect()
//        }
    }
}
