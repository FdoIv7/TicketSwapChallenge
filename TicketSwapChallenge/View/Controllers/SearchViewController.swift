//
//  SearchViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 01/08/22.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let searchViewModel = SearchViewModel()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchController.searchBar.placeholder = Constants.UIText.searchArtists
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        return searchController
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.Fonts.heavy, size: 16)
        label.text = Constants.UIText.enterArtist
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setDelegates()
        searchController.searchBar.searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { [weak self] in self?.searchController.searchBar.searchTextField.text }
            .subscribe(onNext: { [weak self] text in
                guard let artist = text else { return }
                self?.search(for: artist)
            })
            .disposed(by: disposeBag)
    }
    
    private func setView() {
        addSubviews()
        setConstraints()
        setViewLook()
    }
    
    private func addSubviews() {
        view.addSubview(instructionsLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            instructionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setViewLook() {
        setNavBar()
        setTabBar()
        view.backgroundColor = .darkBackground
    }
    
    private func setDelegates() {
        self.searchController.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = ""
        searchController.searchBar.becomeFirstResponder()
    }
    
    private func setNavBar() {
        title = Constants.Titles.search
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .darkBackground
        navigationController?.navigationBar.barTintColor = .darkBackground
        setSearchController()
    }
    
    private func setSearchController() {
        navigationItem.searchController = searchController
    }
    
    private func setTabBar() {
        navigationController?.tabBarItem.image = UIImage(systemName: Constants.Images.magnifying)
        navigationController?.tabBarItem.selectedImage = UIImage(systemName: Constants.Images.selectedMagnifying)
    }
    
    private func search(for artist: String) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultsController.delegate = self
        searchViewModel
            .performSearch(with: artist)
            .observe(on: MainScheduler.instance)
            .retry(3)
            .subscribe(onNext: { response in
                let artists = response.artists.items
                resultsController.updateView(with: artists)
            }, onError: { [weak self] err in
                let message = Constants.UIText.noResults
                self?.showError(message: message)
                print("Error getting results = \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: Constants.UIText.wrong, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.UIText.ok, style: .default)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}
extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapArtistResult(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate { }
