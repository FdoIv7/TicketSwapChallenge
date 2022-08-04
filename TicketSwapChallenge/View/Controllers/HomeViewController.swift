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
        setView()
        setDelegates()
        getNewReleases()
        print("-------------------------------------")
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
        //setTabBar()
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
        title = "New Releases"
    }

    /// REFACTOR THIS INTO ITS OWN CLASS
//    private func setTabBar() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .darkBackground
//        tabBarController?.tabBar.tintColor = .white
//        tabBarController?.tabBar.standardAppearance = appearance
//        tabBarController?.tabBar.scrollEdgeAppearance = appearance
//        tabBarController?.tabBar.isTranslucent = false
//        tabBarController?.tabBar.layer.shadowOffset = .zero
//        tabBarController?.tabBar.layer.shadowRadius = 2
//        tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
//        tabBarController?.tabBar.layer.shadowOpacity = 0.5
//        navigationController?.tabBarItem.image = UIImage(systemName: "house")
//        navigationController?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
//    }

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
                    let viewModel = AlbumCellViewModel(artist: album.artists.first?.name ?? "-", imageURL: imageURL, albumName: album.name)
                    self.newReleasesViewModels.append(viewModel)
                    //print("View Models async = \(self.newReleasesViewModels)")
                    self.collectionView.reloadData()
                }
            }, onError: { error in
                // Update UI with error
                print("error home view controller = \(error)")
            })
            .disposed(by: disposeBag)
        
        //print("View Models = \(newReleasesViewModels)")
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
        cell.configure(with: newReleasesViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = newAlbumReleases[indexPath.row]
        let albumController = AlbumDetailViewController(album: album)
        albumController.title = album.name
        //albumController.hidesBottomBarWhenPushed = false
        //self.navigationItem.largeTitleDisplayMode = .never
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
