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

    struct UIText {
        static let ok = "Ok"
        static let wrong = "Something went wrong"
        static let popularSongs = "Popular Songs"
        static let albums = "Albums"
        static let errorAlbums = "Error getting albums"
        static let errorSongs = "Error getting songs"
        static let errorNewReleases = "Error getting new releases"
        static let error = "Error"
        static let errorSignIn = "Something went wrong when signing in"
        static let dismiss = "Dismiss"
        static let signIn = "Sign in with Spotify"
        static let errorAlbumDetails = "Error getting album details"
        static let noResults = "No results, please try again."
        static let enterArtist = "Enter an artist name"
        static let searchArtists = "Search Artists"
    }

    struct Titles {
        static let newReleases = "New Releases"
        static let ticketSwap = "Ticket Swap"
        static let search = "Search"
    }
    struct Images {
        static let musician = "musician"
        static let photo = "photo"
        static let magnifying = "magnifyingglass.circle"
        static let selectedMagnifying = "magnifyingglass.circle.fill"
        static let house = "house"
        static let selectedHouse = "house.fill"
    }

    struct IDs {
        static let cell = "cell"
    }

    struct Fonts {
        static let heavy = "Avenir Heavy"
        static let avenir = "Avenir"   
    }
}
