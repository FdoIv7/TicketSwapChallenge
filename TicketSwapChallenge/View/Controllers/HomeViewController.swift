//
//  HomeViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 17/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    let homeViewModel = HomeViewModel()
    var newReleasesViewModels = [AlbumCellViewModel]()
    var newAlbumReleases = [Album]()
    private let disposeBag = DisposeBag()
    
    private lazy var newReleasesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setDelegates()
        getNewReleases()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewLook()
    }

    private func setView() {
        addSubviews()
        setConstraints()
    }

    private func setViewLook() {
        view.backgroundColor = .darkBackground
        setNavBar()
    }

    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setNavBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .darkBackground
        navigationController?.navigationBar.barTintColor = .darkBackground
        title = Constants.Titles.newReleases
    }

    private func getNewReleases() {
        homeViewModel
            .getNewReleases()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] res in
                guard let self = self else { return }
                self.newAlbumReleases = res.albums.items
                self.setViewModels(with: self.newAlbumReleases)
            }, onError: { [weak self] error in
                print("Error getting new releases = \(error)")
                let message = Constants.UIText.errorNewReleases
                self?.showError(message: message)
            })
            .disposed(by: disposeBag)
    }

    private func setViewModels(with albums: [Album]) {
        newReleasesViewModels.removeAll()
        for album in albums {
            let imageURL = URL(string: album.images.first?.url ?? "")
            let viewModel = AlbumCellViewModel(artist: album.artists.first?.name ?? "-", imageURL: imageURL, albumName: album.name)
            self.newReleasesViewModels.append(viewModel)
            self.collectionView.reloadData()
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: Constants.UIText.wrong, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.UIText.ok, style: .default)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

    private func setConstraints() {
        let safeGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func addSubviews() {
        view.addSubview(collectionView)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newReleasesViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: newReleasesViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = newAlbumReleases[indexPath.row]
        let albumController = AlbumDetailViewController(album: album)
        albumController.title = album.name
        navigationController?.pushViewController(albumController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 75
        return CGSize(width: collectionViewSize / 2, height: 180)
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
