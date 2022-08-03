//
//  SearchViewModel.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 23/07/22.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    func performSearch(with query: String) -> Observable<SearchResponse> {
        // Update URL
        let searchURLString = Constants.Network.baseURL + "/search?limit=5&type=artist&q=" + (query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        return Observable
            .just(searchURLString)
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
            .map { response, data -> SearchResponse in
                if 200..<300 ~= response.statusCode {
                    let results = try JSONSerialization.jsonObject(with: data)
                    print("Artist result = \(results)")
                    return try JSONDecoder().decode(SearchResponse.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }
    }
}
