//
//  ArtistDetailsViewModel.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 03/08/22.
//

import Foundation
import RxSwift
import RxCocoa

final class ArtistDetailsViewModel {

    func getTopSongs(for artistId: String) -> Observable<TrackResponse> {
        let artistEndpoint = "/artists/"
        let topTracksEndpoint = "/top-tracks?market=NL"
        let topSongsURLString = Constants.Network.baseURL + artistEndpoint + artistId + topTracksEndpoint

        return Observable
            .just(topSongsURLString)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                guard let url = URL(string: url) else { return Observable.empty() }
                var request = URLRequest(url: url)
                var response: Observable<(response: HTTPURLResponse, data: Data)>?
                AuthManager.shared.callWithLatestToken { token in
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.timeoutInterval = 30
                    response = URLSession.shared.rx.response(request: request)
                }
                guard let response = response else { return Observable.empty() }
                return response
            }
            .map { response, data -> TrackResponse in
                if 200..<300 ~= response.statusCode {
                    let tracks = try JSONDecoder().decode(TrackResponse.self, from: data)
                    return tracks
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }

    func getAlbums(for artistId: String) -> Observable<AlbumResponse> {
        let artistEndpoint = "/artists/"
        let albumsEndpoint = "/albums"
        let albumsURLString = Constants.Network.baseURL + artistEndpoint + artistId + albumsEndpoint

        return Observable
            .just(albumsURLString)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                guard let url = URL(string: url) else { return Observable.empty() }
                var request = URLRequest(url: url)
                var response: Observable<(response: HTTPURLResponse, data: Data)>?
                AuthManager.shared.callWithLatestToken { token in
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.timeoutInterval = 30
                    response = URLSession.shared.rx.response(request: request)
                }
                guard let response = response else { return Observable.empty() }
                return response
            }
            .map { response, data -> AlbumResponse in
                if 200..<300 ~= response.statusCode {
                    let albums = try JSONDecoder().decode(AlbumResponse.self, from: data)
                    return albums
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }
}
