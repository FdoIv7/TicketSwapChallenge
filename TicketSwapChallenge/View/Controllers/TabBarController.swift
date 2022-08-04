//
//  TabBarController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 02/08/22.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewControllers()
        setLook()
    }
    
    private func createViewControllers() {
        let homeViewController = HomeViewController()
        let searchViewController = SearchViewController()
        
        homeViewController.title = Constants.Titles.newReleases
        homeViewController.tabBarItem.image = UIImage(systemName: Constants.Images.house)
        homeViewController.tabBarItem.selectedImage = UIImage(systemName: Constants.Images.selectedHouse)

        searchViewController.title = Constants.Titles.search
        searchViewController.tabBarItem.image = UIImage(systemName: Constants.Images.magnifying)
        searchViewController.tabBarItem.selectedImage = UIImage(systemName: Constants.Images.selectedMagnifying)

        let navHomeController = UINavigationController(rootViewController: homeViewController)
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        
        setViewControllers([navHomeController, searchNavController], animated: true)
    }

    private func setLook() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkBackground
        tabBar.tintColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.5
    }
}
