//
//  AlbumResponse.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 24/07/22.
//

import Foundation

struct AlbumResponse: Codable {
    let items: [Album]

    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Album: Codable {
    let type: String
    let artists: [Artist]
    let id: String
    let name: String
    let images: [AlbumImage]
    let releaseDate: String
    let totalTracks: Int
    //let tracks: SongResponse

    private enum CodingKeys: String, CodingKey {
        case type = "album_type"
        case artists
        case id
        case images
        case name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        //case tracks 
    }
}

struct AlbumImage: Codable {
    let width: Int
    let height: Int
    let url: String
}


//{
//    albums =     {
//        href = "https://api.spotify.com/v1/browse/new-releases?locale=en-US%2Cen%3Bq%3D0.9&offset=0&limit=3";
//        items =         (
//            {
//                "album_type" = album;
//                  =                 (
//                    {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/0CDUUM6KNRvgBFYIbWxJwV";
//                        };
//                        href = "https://api.spotify.com/v1/artists/0CDUUM6KNRvgBFYIbWxJwV";
//                        id = 0CDUUM6KNRvgBFYIbWxJwV;
//                        name = Dawes;
//                        type = artist;
//                        uri = "spotify:artist:0CDUUM6KNRvgBFYIbWxJwV";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//                );
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/album/24FkcvXRLoG17447domdkg";
//                };
//                href = "https://api.spotify.com/v1/albums/24FkcvXRLoG17447domdkg";
//                id = 24FkcvXRLoG17447domdkg;
//                  =                 (
//                    {
//                        height = 640;
//                        url = "https://i.scdn.co/image/ab67616d0000b27373aee5a2622de90bd9d814dd";
//                        width = 640;
//                    },
//                    {
//                        height = 300;
//                        url = "https://i.scdn.co/image/ab67616d00001e0273aee5a2622de90bd9d814dd";
//                        width = 300;
//                    },
//                    {
//                        height = 64;
//                        url = "https://i.scdn.co/image/ab67616d0000485173aee5a2622de90bd9d814dd";
//                        width = 64;
//                    }
//                );
//                name = "Misadventures Of Doomscroller";
//                "release_date" = "2022-07-22";
//                "release_date_precision" = day;
//                "total_tracks" = 7;
//                type = album;
//                uri = "spotify:album:24FkcvXRLoG17447domdkg";
//            },
//            {
//                "album_type" = single;
//                artists =                 (
//                    {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/4MoAOfV4ROWofLG3a3hhBN";
//                        };
//                        href = "https://api.spotify.com/v1/artists/4MoAOfV4ROWofLG3a3hhBN";
//                        id = 4MoAOfV4ROWofLG3a3hhBN;
//                        name = "Jon Pardi";
//                        type = artist;
//                        uri = "spotify:artist:4MoAOfV4ROWofLG3a3hhBN";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//                    AE,
//                    AG,
//                );
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/album/5XORipB5PhMoQx46rjX9o9";
//                };
//                href = "https://api.spotify.com/v1/albums/5XORipB5PhMoQx46rjX9o9";
//                id = 5XORipB5PhMoQx46rjX9o9;
//                images =                 (
//                    {
//                        height = 640;
//                        url = "https://i.scdn.co/image/ab67616d0000b273b373f47e1ac568fedcc666d1";
//                        width = 640;
//                    },
//                    {
//                        height = 300;
//                        url = "https://i.scdn.co/image/ab67616d00001e02b373f47e1ac568fedcc666d1";
//                        width = 300;
//                    },
//                    {
//                        height = 64;
//                        url = "https://i.scdn.co/image/ab67616d00004851b373f47e1ac568fedcc666d1";
//                        width = 64;
//                    }
//                );
//                name = "Mr. Saturday Night";
//                "release_date" = "2022-07-22";
//                "release_date_precision" = day;
//                "total_tracks" = 1;
//                type = album;
//                uri = "spotify:album:5XORipB5PhMoQx46rjX9o9";
//            },
//            {
//                "album_type" = single;
//                artists =                 (
//                    {
//                        "external_urls" =                         {
//                            spotify = "https://open.spotify.com/artist/3M3wTTCDwicRubwMyHyEDy";
//                        };
//                        href = "https://api.spotify.com/v1/artists/3M3wTTCDwicRubwMyHyEDy";
//                        id = 3M3wTTCDwicRubwMyHyEDy;
//                        name = Shygirl;
//                        type = artist;
//                        uri = "spotify:artist:3M3wTTCDwicRubwMyHyEDy";
//                    }
//                );
//                "available_markets" =                 (
//                    AD,
//                    AE,
//                    AG,
//                );
//                "external_urls" =                 {
//                    spotify = "https://open.spotify.com/album/2cQKZRfGU3kSnxyNCHZuiZ";
//                };
//                href = "https://api.spotify.com/v1/albums/2cQKZRfGU3kSnxyNCHZuiZ";
//                id = 2cQKZRfGU3kSnxyNCHZuiZ;
//                images =                 (
//                    {
//                        height = 640;
//                        url = "https://i.scdn.co/image/ab67616d0000b2734a32156af86df20f5a79cfc8";
//                        width = 640;
//                    },
//                    {
//                        height = 300;
//                        url = "https://i.scdn.co/image/ab67616d00001e024a32156af86df20f5a79cfc8";
//                        width = 300;
//                    },
//                    {
//                        height = 64;
//                        url = "https://i.scdn.co/image/ab67616d000048514a32156af86df20f5a79cfc8";
//                        width = 64;
//                    }
//                );
//                name = "Coochie (a bedtime story)";
//                "release_date" = "2022-07-20";
//                "release_date_precision" = day;
//                "total_tracks" = 3;
//                type = album;
//                uri = "spotify:album:2cQKZRfGU3kSnxyNCHZuiZ";
//            }
//        );
//        limit = 3;
//        next = "https://api.spotify.com/v1/browse/new-releases?locale=en-US%2Cen%3Bq%3D0.9&offset=3&limit=3";
//        offset = 0;
//        previous = "<null>";
//        total = 100;
//    };
//}
