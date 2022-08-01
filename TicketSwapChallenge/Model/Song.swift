//
//  Song.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import Foundation

struct Song: Codable {
    let album: Album?
    let artists: [Artist]
    let discNumber: Int?
    let durationMS: Int?
    //let items: [String: String]
    let id: String
    let name: String
}

struct SongResponse: Codable {
    let items: [Song]
}
