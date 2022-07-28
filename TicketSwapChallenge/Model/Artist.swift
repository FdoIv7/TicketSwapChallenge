//
//  Artist.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import Foundation

struct ArtistResponse {
    
}

struct Artist: Codable {
    //let followers: [String: Int?]
    let externalURLs: [String: String]
    let id: String
    let images: [ArtistImage]? // Watch out since we need to UNWRAP
    let name: String
    let uri: String
    let genres: [String]?
    let type: String

    private enum CodingKeys: String, CodingKey {
        //case followers = "followers"
        case externalURLs = "external_urls"
        case id
        case images
        case name
        case uri
        case genres
        case type
    }
}

struct ArtistImage: Codable {
    let height: Int
    let width: Int
    let url: String

    private enum CodingKeys: String, CodingKey {
        case height
        case width
        case url
    }
}

//artists =                 (
//    {
//        "external_urls" =                         {
//            spotify = "https://open.spotify.com/artist/4MoAOfV4ROWofLG3a3hhBN";
//        };
//        href = "https://api.spotify.com/v1/artists/4MoAOfV4ROWofLG3a3hhBN";
//        id = 4MoAOfV4ROWofLG3a3hhBN;
//        name = "Jon Pardi";
//        type = artist;
//        uri = "spotify:artist:4MoAOfV4ROWofLG3a3hhBN";
//    }
//);
