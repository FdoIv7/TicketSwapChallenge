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
        // let newReleasesURLString = Constants.Network.baseURL + "/browse/new-releases?limit=40"
        let topSongsURLString = Constants.Network.baseURL + "/artists/" + artistId + "/top-tracks?market=US"

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
                    let json = try JSONSerialization.jsonObject(with: data)
                    let tracks = try JSONDecoder().decode(TrackResponse.self, from: data)
                    return tracks
                } else {
                    print("response \(response)")
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }

    func getAlbums(for artistId: String) -> Observable<AlbumResponse> {
        let albumsURLString = Constants.Network.baseURL + "/artists/" + artistId + "/albums"

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
                    let json = try JSONSerialization.jsonObject(with: data)
                    let albums = try JSONDecoder().decode(AlbumResponse.self, from: data)
                    print("albums = \(albums)")
                    return albums
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }
}
