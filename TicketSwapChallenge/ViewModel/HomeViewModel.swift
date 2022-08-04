//
//  HomeViewModel.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 23/07/22.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {

    func getNewReleases() -> Observable<NewReleases> {
        let newReleasesEndpoint = "/browse/new-releases?limit=40"
        let newReleasesURLString = Constants.Network.baseURL + newReleasesEndpoint
        return Observable
            .just(newReleasesURLString)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                guard let url = URL(string: url) else { return Observable.empty() }
                var request = URLRequest(url: url)
                var response: Observable<(response: HTTPURLResponse, data: Data)>!
                AuthManager.shared.callWithLatestToken { token in
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.timeoutInterval = 30
                    response = URLSession.shared.rx.response(request: request)
                }
                guard let response = response else { return Observable.empty() }
                return response
            }
            .map { response, data -> NewReleases in
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(NewReleases.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }
}
