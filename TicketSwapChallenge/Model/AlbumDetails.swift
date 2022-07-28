//
//  AlbumDetails.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 27/07/22.
//

import Foundation

struct AlbumDetails: Codable {
    let type: String
    let artists: [Artist]
    let externalURLs: [String: String]
    let id: String
    let images: [AlbumImage]
    let name: String
    let tracks: SongResponse

    private enum CodingKeys: String, CodingKey {
        case type = "album_type"
        case artists
        case externalURLs = "external_urls"
        case id, images, name, tracks
    }
}
