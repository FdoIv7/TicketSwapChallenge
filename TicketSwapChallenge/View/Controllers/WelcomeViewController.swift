//
//  WelcomeViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitle("Sign in with Spotify", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func addSubviews() {
        view.addSubview(button)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setNavBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Ticket Swap"
    }
    
    private func setView() {
        addSubviews()
        setConstraints()
        setNavBar()
        view.backgroundColor = .systemGreen
    }

    @objc private func logInTapped() {
        let authController = AuthViewController()
        authController.isSignedIn = { [weak self] signedIn in
            DispatchQueue.main.async {
                self?.handleSignIn(signedIn: signedIn)
            }
        }
        authController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authController, animated: true )
    }

    private func handleSignIn(signedIn: Bool) {
         // If we successfully sign in
        if signedIn {
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let homeViewController = HomeViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true)
        
    }
}
