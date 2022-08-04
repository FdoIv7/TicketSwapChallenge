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

enum SectionType {
    case popularSongs(viewModels: [TrackCellViewModel]) // 1
    case albums // 2
}

final class ArtistDetailViewController: UIViewController {
    
    private let artist: Artist
    private let id: String
    private var popularTracks: [Track] = []
    private var albums: [Album] = []
    
    private var trackCellViewModels = [TrackCollectionCellViewModel]()
    private var albumCellViewModels = [AlbumCellViewModel]()
    private let viewModel = ArtistDetailsViewModel()
    private var sections = [SectionType]()
    private let disposeBag = DisposeBag()
    
    private lazy var artistImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            return self?.createCollectionSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ArtistAlbumCollectionCell.self, forCellWithReuseIdentifier: ArtistAlbumCollectionCell.identifier)
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .darkBackground
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .systemOrange
        return scrollView
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
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
        
        // Songs Group
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let songsGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: songsGroup)
        return section
    }
    
    private func configureAlbumsSection() -> NSCollectionLayoutSection? {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let layoutSize = NSCollectionLayoutSize(widthDimension: .absolute(170), heightDimension: .absolute(170))
        let albumsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1 )
        // Section
        let section = NSCollectionLayoutSection(group: albumsGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        // only show the table view if we do get data back
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBackground
        title = self.artist.name
        navigationItem.largeTitleDisplayMode = .never
        print("Artist = \(artist)")
        setDelegates()
        getArtistDetails()
        configureCollectionView()
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
                print("Songs = \(songs)")
                collectionView.reloadData()
            }, onError: { err in
                print("Error = \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    private func getAlbums(id: String) {
        viewModel
            .getAlbums(for: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] albums in
                print("Albums from vc = \(albums)")
                self.albums = albums.items
                createAlbumsViewModels(with: self.albums)
                collectionView.reloadData()
            }, onError: { err in
                print("Error from vc = \(err)")
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
            artistImage.image = UIImage(named: "musician")
        }
    }
    
    private func addSubviews() {
        //view.addSubview(scrollView)
        //scrollView.addSubview(artistImage)
        view.addSubview(artistImage)
        view.addSubview(collectionView)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Scroll view
            //            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            //            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            // General view
            artistImage.topAnchor.constraint(equalTo: guide.topAnchor),
            
            //artistImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            //artistImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            artistImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            artistImage.widthAnchor.constraint(equalToConstant: 200),
            artistImage.heightAnchor.constraint(equalToConstant: 200),
            collectionView.topAnchor.constraint(equalTo: artistImage.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ArtistDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension ArtistDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader else { return UICollectionReusableView() }
        header.configure(title: "Albums")
        return header
    }
}
