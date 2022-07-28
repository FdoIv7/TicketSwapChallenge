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

    struct Layout {
        static let cornerRadius: CGFloat = 10
        static let fontFifteen: CGFloat = 15
        static let fontTwenty: CGFloat = 20
        static let heartSize: CGFloat = 35
        static let shadowRadius: CGFloat = 7
        static let shadowOpacity: Float = 0.7
    }
}
