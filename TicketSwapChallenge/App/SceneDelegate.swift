//
//  SceneDelegate.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 14/07/22.
//

import UIKit
import SpotifyiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let homeViewController = HomeViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        if AuthManager.shared.isSigned {
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        }
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }

    // For spotify authorization and authentication flow
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
      print("connected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }
}
