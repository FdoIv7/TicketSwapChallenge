//
//  SearchResultsViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 02/08/22.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapArtistResult(_ controller: UIViewController)
}

final class SearchResultsViewController: UIViewController {

    weak var delegate: SearchResultsViewControllerDelegate?
    private var artistsResult: [Artist] = []
    private var searchResultsViewModels: [SearchResultCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }

    lazy var resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArtistResultTableViewCell.self, forCellReuseIdentifier: ArtistResultTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        return tableView
    }()

    private func setView() {
        setViewLook()
        addSubviews()
        setConstraints()
    }

    private func addSubviews() {
        view.addSubview(resultsTableView)
    }

    private func setConstraints() {
        let safeGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setViewLook() {
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsTableView.isHidden = true
    }

    private func setDelegates() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }

    public func updateView(with artists: [Artist]) {
        self.artistsResult.removeAll()
        self.searchResultsViewModels.removeAll()
        self.artistsResult = artists
        for artist in artists {
            let imageURL = URL(string: artist.images?.first?.url ?? "")
            let viewModel = SearchResultCellViewModel(artist: artist.name, imageURL: imageURL, id: artist.id)
            searchResultsViewModels.append(viewModel)
        }
        resultsTableView.reloadData()
        resultsTableView.isHidden = false
    }

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistsResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistResultTableViewCell.identifier, for: indexPath)
                as? ArtistResultTableViewCell else { return UITableViewCell() }
        let viewModel = self.searchResultsViewModels[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artistsResult[indexPath.row]
        let artistDetailViewController = ArtistDetailViewController(artist: artist)
        delegate?.didTapArtistResult(artistDetailViewController)
    }
}
