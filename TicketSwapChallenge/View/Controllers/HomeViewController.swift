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
    var newReleasesViewModels = [NewReleasesViewModel]()
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

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
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
        setDelegates()
        getNewReleases()
        setView()
        print("-------------------------------------")
//        NertworkManager.shared
//            .getNewReleases()
//            .subscribe(onNext: { res in
//                print("Res! = \(res)")
//            })
//            .disposed(by: disposeBag)
    }

    private func setView() {
        addSubviews()
        setConstraints()
        setViewLook()
    }

    private func setViewLook() {
        view.backgroundColor = .paletteBackground
    }

    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func getNewReleases() {
        homeViewModel
            .getNewReleases()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] res in
                guard let self = self else { return }
                self.newAlbumReleases = res.albums.items
                // set our view models
                for album in self.newAlbumReleases {
                    guard let imageURL = URL(string: album.images.first?.url ?? "") else { return }
                    let viewModel = NewReleasesViewModel(artist: album.artists.first?.name ?? "-", imageURL: imageURL, albumName: album.name)
                    self.newReleasesViewModels.append(viewModel)
                    print("View Models async = \(self.newReleasesViewModels)")
                    self.collectionView.reloadData()
                }
            }, onError: { error in
                // Update UI with error
                print("error home view controller = \(error)")
            })
            .disposed(by: disposeBag)
        
        print("View Models = \(newReleasesViewModels)")
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
        view.addSubview(spinner)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newReleasesViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        // Configure our cell using the viewModels
        cell.configure(with: newReleasesViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = newAlbumReleases[indexPath.row]
        let albumController = AlbumDetailViewController(album: album)
        albumController.title = album.name
        // Navcontroller is nil in some cases
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
