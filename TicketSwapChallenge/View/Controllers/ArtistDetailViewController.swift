//
//  ArtistDetailViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

final class ArtistDetailViewController: UIViewController {
    
    private let artist: Artist
    private let id: String
    private var popularTracks: [Track] = []
    private var albums: [Album] = []
    
    private var trackCellViewModels = [TrackCollectionCellViewModel]()
    private var albumCellViewModels = [AlbumCellViewModel]()
    private let viewModel = ArtistDetailsViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var artistImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: Constants.Images.photo)
        imageView.tintColor = .white
        imageView.layer.shadowRadius = Constants.Layout.shadowRadius
        imageView.layer.shadowOpacity = Constants.Layout.shadowOpacity
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var songsHeader: UICollectionReusableView = {
        let header = CollectionViewHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            return self?.createCollectionSection(for: sectionIndex)
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        layout.configuration = config

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.IDs.cell)
        collectionView.register(ArtistAlbumCollectionCell.self, forCellWithReuseIdentifier: ArtistAlbumCollectionCell.identifier)
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .darkBackground
        return collectionView
    }()
    
    private func createCollectionSection(for section: Int) -> NSCollectionLayoutSection? {
        switch section {
        case 0:
            return configurePopularSongsSection()
        case 1:
            return configureAlbumsSection()
        default:
            return configurePopularSongsSection() // Default section
        }
    }
    
    private func configurePopularSongsSection() -> NSCollectionLayoutSection? {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)

        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)

        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let songsGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: songsGroup)
        section.boundarySupplementaryItems = [header]
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        return section
    }
    
    private func configureAlbumsSection() -> NSCollectionLayoutSection? {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)

        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
        header.contentInsets = NSDirectionalEdgeInsets(top: -20, leading: 16, bottom: 20, trailing: 0)
        
        let layoutSize = NSCollectionLayoutSize(widthDimension: .absolute(170), heightDimension: .absolute(170))
        let albumsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1 )
        // Section
        let section = NSCollectionLayoutSection(group: albumsGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewLook()
        setDelegates()
        getArtistDetails()
        setView()
    }
    
    init(artist: Artist) {
        self.artist = artist
        self.id = artist.id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViewLook() {
        view.backgroundColor = .darkBackground
        title = self.artist.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setView() {
        addSubviews()
        setConstraints()
        setArtistView()
    }
    
    private func getArtistDetails() {
        self.getTopSongs(id: artist.id)
        self.getAlbums(id: artist.id)
    }
    
    private func getTopSongs(id: String) {
        viewModel
            .getTopSongs(for: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] songs in
                self.popularTracks = songs.tracks
                self.createTrackViewModels(with: self.popularTracks)
            }, onError: { [weak self] err in
                let message = Constants.UIText.errorSongs
                self?.showError(message: message)
                print("Error getting songs = \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    private func getAlbums(id: String) {
        viewModel
            .getAlbums(for: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] albums in
                self.albums = albums.items
                self.createAlbumsViewModels(with: self.albums)
            }, onError: { [weak self] err in
                let message = Constants.UIText.errorAlbums
                self?.showError(message: message)
                print("Error getting albums = \(err)")
            })
            .disposed(by: disposeBag)
    }
    
    private func createTrackViewModels(with songs: [Track]) {
        trackCellViewModels.removeAll()
        for song in songs {
            let viewModel = TrackCollectionCellViewModel(trackName: song.trackName, albumName: song.album.name,
                                                         artistName: song.artists.first?.name ?? "")
            trackCellViewModels.append(viewModel)
        }
        let topFiveSongs = trackCellViewModels.prefix(5)
        trackCellViewModels = Array(topFiveSongs)
        collectionView.reloadData()
    }
    
    private func createAlbumsViewModels(with albums: [Album]) {
        albumCellViewModels.removeAll()
        for album in albums {
            let imageURL = URL(string: album.images.first?.url ?? "")
            let viewModel = AlbumCellViewModel(artist: album.artists.first?.name ?? "", imageURL: imageURL, albumName: album.name)
            albumCellViewModels.append(viewModel)
        }
        collectionView.reloadData()
    }
    
    private func setArtistView() {
        if let imageURL = URL(string: artist.images?.first?.url ?? "") {
            artistImage.sd_setImage(with: imageURL)
        } else {
            artistImage.image = UIImage(named: Constants.Images.musician)
        }
    }
    
    private func addSubviews() {
        view.addSubview(artistImage)
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            artistImage.topAnchor.constraint(equalTo: guide.topAnchor),
            artistImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            artistImage.widthAnchor.constraint(equalToConstant: 200),
            artistImage.heightAnchor.constraint(equalToConstant: 200),
            collectionView.topAnchor.constraint(equalTo: artistImage.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: Constants.UIText.wrong, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.UIText.ok, style: .default)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ArtistDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return trackCellViewModels.count
        case 1:
            return albumCellViewModels.count
        default:
            return 1
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier,
                                                                for: indexPath) as? TrackCollectionViewCell
            else { return UICollectionViewCell() }
            let viewModel = trackCellViewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistAlbumCollectionCell.identifier, for: indexPath) as? ArtistAlbumCollectionCell else { return UICollectionViewCell() }
            let viewModel = albumCellViewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader else { return UICollectionReusableView() }
            header.configure(title: Constants.UIText.popularSongs)
            return header
        case 1:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader else { return UICollectionReusableView() }
            header.configure(title: Constants.UIText.albums)
            return header
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}
