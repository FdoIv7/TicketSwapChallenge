//
//  SearchResponse.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 02/08/22.
//

import Foundation

struct SearchResponse: Codable {
    let artists: ArtistsSearchResponse
    // Albums, tracks and playlists can also be implemented
}

struct ArtistsSearchResponse: Codable {
    let items: [Artist]
}
