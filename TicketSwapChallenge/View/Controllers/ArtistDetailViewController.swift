//
//  ArtistDetailViewController.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import UIKit

final class ArtistDetailViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        // only show the table view if we do get data back
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setView() {
        addSubviews()
        setConstraints()
    }

    private func addSubviews() {
        
    }

    private func setConstraints() {
        
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
