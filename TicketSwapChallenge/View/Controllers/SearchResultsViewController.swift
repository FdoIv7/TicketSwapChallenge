//
//  SearchResultsViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 02/08/22.
//

import UIKit

final class SearchResultsViewController: UIViewController {

    private var artistsResult = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setView()
        setDelegates()
    }

    private lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArtistResultTableViewCell.self, forCellReuseIdentifier: ArtistResultTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setView() {
        view.backgroundColor = .clear
    }

    private func setDelegates() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }

    public func updateView(with artists: [Artist]) {
        view.backgroundColor = .systemOrange
        self.artistsResult = artists
        for artist in artists {
            print("Artist name = \(artist.name)")
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistsResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistResultTableViewCell.identifier, for: indexPath.row)
                as? ArtistResultTableViewCell else { return UITableViewCell() }
        return cell
    }
}
