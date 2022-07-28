//
//  AlbumDetailViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 26/07/22.
//

import UIKit
import RxSwift
import RxCocoa

final class AlbumDetailViewController: UIViewController {

    private let album: Album
    let albumDetailViewModel = AlbumDetailViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paletteBackground
        getAlbumDetails()
    }

    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// To Do:
    /// ---------- Define View Controllers Look ------------

    private func getAlbumDetails() {
        albumDetailViewModel
            .getAlbumDetails(for: album)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { album in
                print("Album = \(album)")
            })
            .disposed(by: disposeBag)
    }
}
