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

//{
//    href = "https://api.spotify.com/v1/albums/75AMuGJ8j2cM7smZ0HhJzn/tracks?offset=0&limit=50&locale=en-US,en;q=0.9";
//    ite ms =         (
//                    {
//            artists =                 (
//                                    {
//                    "external_urls" =                         {
//                        spotify = "https://open.spotify.com/artist/23DYJsw4uSCguIqiTIDtcN";
//                    };
//                    href = "https://api.spotify.com/v1/artists/23DYJsw4uSCguIqiTIDtcN";
//                    id = 23DYJsw4uSCguIqiTIDtcN;
//                    name = Southside;
//                    type = artist;
//                    uri = "spotify:artist:23DYJsw4uSCguIqiTIDtcN";
//                },
//                                    {
//                    "external_urls" =                         {
//                        spotify = "https://open.spotify.com/artist/3hcs9uc56yIGFCSy9leWe7";
//                    };
//                    href = "https://api.spotify.com/v1/artists/3hcs9uc56yIGFCSy9leWe7";
//                    id = 3hcs9uc56yIGFCSy9leWe7;
//                    name = "Lil Durk";
//                    type = artist;
//                    uri = "spotify:artist:3hcs9uc56yIGFCSy9leWe7";
//                }
//            );
//            "available_markets" =                 (
//                AD,
//                AE,
//                AG,
//                AL,
//                AM,
//                FM,
//                FR,
//                GA,
//            );
//            "disc_number" = 1;
//            "duration_ms" = 173987;
//            explicit = 1;
//            "external_urls" =                 {
//                spotify = "https://open.spotify.com/track/5HN3ikspb1MOyJ0MMjn55I";
//            };
//            href = "https://api.spotify.com/v1/tracks/5HN3ikspb1MOyJ0MMjn55I";
//            id = 5HN3ikspb1MOyJ0MMjn55I;
//            "is_local" = 0;
//            name = "Save Me";
//            "preview_url" = "https://p.scdn.co/mp3-preview/6100320bebd97479993d1965f5ff12943844a2fa?cid=4f3619a38309480a98a9e1cb55ed21b8";
//            "track_number" = 1;
//            type = track;
//            uri = "spotify:track:5HN3ikspb1MOyJ0MMjn55I";
//        }
//    );
//    limit = 50;
//    next = "<null>";
//    offset = 0;
//    previous = "<null>";
//    total = 1;
//}
