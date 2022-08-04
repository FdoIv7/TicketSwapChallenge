//
//  AlbumDetailViewModel.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 27/07/22.
//

import Foundation
import RxSwift
import RxCocoa

final class AlbumDetailViewModel {
    
    func getAlbumDetails(for album: Album) -> Observable<AlbumDetails> {
        // Update URL
        let albumsEndpoint = "/albums/"
        let albumURLString = Constants.Network.baseURL + albumsEndpoint + album.id
        return Observable
            .just(albumURLString)
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
            .map { response, data -> AlbumDetails in
                if 200..<300 ~= response.statusCode {
                    let json = try JSONSerialization.jsonObject(with: data)
                    return try JSONDecoder().decode(AlbumDetails.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }
}

