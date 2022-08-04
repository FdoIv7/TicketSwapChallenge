//
//  AlbumDetailViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 26/07/22.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class AlbumDetailViewController: UIViewController {
    
    private let album: Album
    let albumDetailViewModel = AlbumDetailViewModel()
    let disposeBag = DisposeBag()
    var albumTracks = [Song]()
    var trackCellViewModels = [TrackCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        getAlbumDetails()
        songsTableView.delegate = self
        songsTableView.dataSource = self
    }
    
    private lazy var albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        imageView.layer.shadowRadius = Constants.Layout.shadowRadius
        imageView.layer.shadowOpacity = Constants.Layout.shadowOpacity
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowColor = UIColor.black.cgColor
        return imageView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [albumNameLabel, artistLabel, releaseDateLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = UIFont(name: "Avenir Heavy", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Heavy", size: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 12)
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var songsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .darkGray
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubviews()
        setConstraints()
        setViewLook()
    }
    
    private func addSubviews() {
        view.addSubview(albumImage)
        view.addSubview(descriptionStackView)
        view.addSubview(songsTableView)
    }
    
    private func setViewLook() {
        setNavBar()
        //setTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setNavBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .darkBackground
    }
    
    private func setConstraints() {
        let safeGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            albumImage.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            albumImage.heightAnchor.constraint(equalToConstant: 200),
            albumImage.widthAnchor.constraint(equalToConstant: 200),
            albumImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionStackView.topAnchor.constraint(equalTo: albumImage.bottomAnchor, constant: 8),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            songsTableView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 16),
            songsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            songsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            songsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getAlbumDetails() {
        albumDetailViewModel
            .getAlbumDetails(for: album)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] album in
                self.albumTracks = album.tracks.items
                self.createTrackViewModels(with: self.albumTracks)
                self.setAlbumView(with: album)
            }, onError: { error in
                print("Error Album Detail = \(error.localizedDescription) ")
            })
            .disposed(by: disposeBag)
    }
    
    private func createTrackViewModels(with songs: [Song]) {
        for track in songs {
            let viewModel = TrackCellViewModel(artistName: track.artists.first?.name ?? "", trackName: track.name)
            self.trackCellViewModels.append(viewModel)
        }
    }
    
    private func setAlbumView(with albumDetails: AlbumDetails) {
        guard let url = URL(string: albumDetails.images.first?.url ?? "") else { return }
        let year = Utilities.getYear(for: album.releaseDate)
        self.albumImage.sd_setImage(with: url)
        self.artistLabel.text = albumDetails.artists.first?.name
        self.albumNameLabel.text = albumDetails.name
        self.releaseDateLabel.text = "• \(year ?? 2021)"
        self.songsTableView.reloadData()
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as?
                SongTableViewCell else { return UITableViewCell() }
        let viewModel = trackCellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
