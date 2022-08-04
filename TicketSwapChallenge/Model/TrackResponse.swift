//
//  TrackResponse.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 03/08/22.
//

import Foundation

struct TrackResponse: Codable {
    let tracks: [Track]
}

struct Track: Codable {
    let album: Album
    let artists: [Artist]
    let trackName: String

    private enum CodingKeys: String, CodingKey {
        case album, artists
        case trackName = "name"
    }
}
