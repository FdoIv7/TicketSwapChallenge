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

//    public func getNewReleases(completion: @escaping(Result<NewReleases, Error>) -> ()) {
//        NertworkManager.shared.getNewReleases { result in
//            switch result {
//            case .success(let newRelease):
//                completion(.success(newRelease))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }

    func getNewReleases() -> Observable<NewReleases> {
        let newReleasesURLString = Constants.Network.baseURL + "/browse/new-releases?limit=40"
        return Observable
            .just(newReleasesURLString)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                guard let url = URL(string: url) else { return Observable.empty() }
                var request = URLRequest(url: url)
                AuthManager.shared.callWithLatestToken { token in
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = HTTPMethod.GET.rawValue
                    request.timeoutInterval = 45
                }
                return URLSession.shared.rx.response(request: request)
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
