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
    let searchViewController = SearchViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let homeNavController = UINavigationController(rootViewController: homeViewController)
//        let searchNavController = UINavigationController(rootViewController: searchViewController)
        let window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSigned {
            // Instead of waiting for an APICall to refresh the token, as soon as we are logedIn we refresh the token
            //AuthManager.shared.refreshAccessToken(completion: nil)
            let tabController = TabBarController()
            //tabController.viewControllers = [homeNavController, searchNavController]
            //searchNavController.tabBarItem.image = UIImage(systemName: "photo")
            window.rootViewController = tabController
        } else {
            let navController = UINavigationController(rootViewController: WelcomeViewController())
            navController.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            navController.navigationBar.prefersLargeTitles = true
            window.rootViewController = navController
        }
        window.makeKeyAndVisible()
        self.window = window
        AuthManager.shared.refreshAccessToken(completion: nil) 
        // Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Mobile/15E148 Safari/604.1
        let dictionary = NSDictionary(object: "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forKey: "UserAgent" as NSCopying)
        if let dict = dictionary as? [String: Any] {
            UserDefaults.standard.register(defaults: dict)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
}
