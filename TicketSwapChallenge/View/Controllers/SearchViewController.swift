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
        searchController.searchBar.placeholder = "Search Artists"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        return searchController
    }()

    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
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
                //print("Text = \(artist)")
                self?.search(for: artist)
                print(artist)
                //print("Artists = \(artists)")
            })
            .disposed(by: disposeBag)
    }

    private func setView() {
        addSubviews()
        setConstraints()
        setViewLook()
    }

    private func addSubviews() {
        
    }

    private func setConstraints() {
        
    }

    private func setViewLook() {
        setNavBar()
        setTabBar()
        view.backgroundColor = .darkBackground
    }

    private func setDelegates() {
        //self.searchController.searchResultsUpdater = self
    }

    private func setNavBar() {
        title = "Search"
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
        navigationController?.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        navigationController?.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
    }

    private func search(for artist: String) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        searchViewModel
            .performSearch(with: artist)
            .observe(on: MainScheduler.instance)
            .retry(3)
            .subscribe(onNext: { [weak self] response in
                print("Response = \(response)")
                let artists = response.artists.items
                // Update UI
                self?.searchController.searchResultsController?.view.backgroundColor = .systemGreen
                resultsController.updateView(with: artists)
            })
            .disposed(by: disposeBag)
    }
}
