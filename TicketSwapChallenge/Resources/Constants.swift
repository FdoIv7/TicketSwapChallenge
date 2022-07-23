//
//  Constants.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 17/07/22.
//

import Foundation

struct Constants {

    struct Network {
        static let accessTokenKey = "access-token-key"
        static let authorizeURL = "https://accounts.spotify.com/authorize"
        static let redirectUri = "https://www.iosacademy.io/"
        static let spotifyClientId = "4f3619a38309480a98a9e1cb55ed21b8"
        static let spotifyClientSecretKey = "23b998b7d97e4c88a5d674f00680ae39"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private%20ugc-image-upload%20playlist-read-private%20playlist-modify-public%20user-follow-read%20playlist-modify-private%20user-library-modify%20user-read-email"
        static let baseURL = "https://api.spotify.com/v1"
    }
//    static let scopes: SPTScope = [
//                                .userReadEmail, .userReadPrivate,
//                                .userReadPlaybackState, .userModifyPlaybackState, .userReadCurrentlyPlaying,
//                                .streaming, .appRemoteControl,
//                                .playlistReadCollaborative, .playlistModifyPublic, .playlistReadPrivate, . playlistModifyPrivate,
//                                .userLibraryModify, .userLibraryRead,
//                                .userTopRead, .userReadPlaybackState, .userReadCurrentlyPlaying,
//                                .userFollowRead, .userFollowModify,
//                            ]
    static let stringScopes = [
                            "user-read-email", "user-read-private",
                            "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
                            "streaming", "app-remote-control",
                            "playlist-read-collaborative", "playlist-modify-public", "playlist-read-private", "playlist-modify-private",
                            "user-library-modify", "user-library-read",
                            "user-top-read", "user-read-playback-position", "user-read-recently-played",
                            "user-follow-read", "user-follow-modify",
                        ]

}
