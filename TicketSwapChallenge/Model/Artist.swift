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
    let followers: [String: Int?]
    let externalURLs: [String: String]
    let id: String
    let images: [ArtistImage]
    let name: String
    let uri: String
    let genres: [String]

    private enum CodingKeys: String, CodingKey {
        case followers = "followers"
        case externalURLs = "external_urls"
        case id
        case images
        case name
        case uri
        case genres
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
//Result = {
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/artist/0TnOYISbd1XYRBk9myaseg";
//    };
//    followers =     {
//        href = "<null>";
//        total = 9442490;
//    };
//    genres =     (
//        "dance pop",
//        latin,
//        "miami hip hop",
//        pop,
//        "pop rap"
//    );
//    href = "https://api.spotify.com/v1/artists/0TnOYISbd1XYRBk9myaseg";
//    id = 0TnOYISbd1XYRBk9myaseg;
//    images =     (
//                {
//            height = 640;
//            url = "https://i.scdn.co/image/ab6761610000e5eb2dc40ac263ef07c16a95af4e";
//            width = 640;
//        },
//                {
//            height = 320;
//            url = "https://i.scdn.co/image/ab676161000051742dc40ac263ef07c16a95af4e";
//            width = 320;
//        },
//                {
//            height = 160;
//            url = "https://i.scdn.co/image/ab6761610000f1782dc40ac263ef07c16a95af4e";
//            width = 160;
//        }
//    );
//    name = Pitbull;
//    popularity = 82;
//    type = artist;
//    uri = "spotify:artist:0TnOYISbd1XYRBk9myaseg";
//}
