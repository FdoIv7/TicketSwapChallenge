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
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: Constants.Fonts.avenir, size: 20)
        button.clipsToBounds = true
        button.setTitle(Constants.UIText.signIn, for: .normal)
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
        title = Constants.Titles.ticketSwap
    }
    
    private func setView() {
        addSubviews()
        setConstraints()
        setNavBar()
        view.backgroundColor = .ticketSwapBlue
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
        if !signedIn {
            let alert = UIAlertController(title: Constants.UIText.error, message: Constants.UIText.errorSignIn, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.UIText.dismiss, style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let tabBarController = TabBarController()

        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController ,animated: true)
    }
}
