//
//  HomeViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 17/07/22.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NertworkManager.shared.getArtist { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                // Update UI to let user something went wrong
                print(error)
                break
            }
        }
        view.backgroundColor = .systemTeal
    }

    private func setView() {
        addSubviews()
        setConstraints()
    }

    private func setConstraints() {
        
    }

    private func addSubviews() {
        
    }
}
