//
//  NetworkManager.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import Foundation
import RxSwift
import RxCocoa

enum HTTPMethod: String {
    case GET
    case POST
}

enum APIError: Error {
    case failedToGetData
    case failedToParseData
}

final class NertworkManager {
    static let shared = NertworkManager()
    
    func getArtist(completion: @escaping(Result<Artist, Error>) -> ()) {
        let id = "0TnOYISbd1XYRBk9myaseg"
        let artistURLString = Constants.Network.baseURL + "/artists/" + id
        guard let url = URL(string: artistURLString) else { return }
        createRequest(url: url, method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                guard let data = data, err == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let artist = try JSONDecoder().decode(Artist.self, from: data)
                    //let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("Artist = \(artist)")
                    print("artist name = \(artist.name)")
                    completion(.success(artist))
                } catch {
                    completion(.failure(error ))
                }
            }
            task.resume()
        }
    }

    func getNewReleases(completion: @escaping(Result<NewReleases, Error>) -> ()) {
        let newReleasesURLString = Constants.Network.baseURL + "/browse/new-releases?limit=50"
        guard let url = URL(string: newReleasesURLString) else { return }
        createRequest(url: url, method: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, response, err in
                guard let data = data, err == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let newReleases = try JSONDecoder().decode(NewReleases.self, from: data)
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("New releases = \(newReleases)")
                    //print("json =\(json)")
                    //completion(.success(newReleases))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

    func getNewReleases() -> Observable<NewReleases> {
        let newReleasesURLString = Constants.Network.baseURL + "/browse/new-releases?limit=50"
        return Observable
            .just(newReleasesURLString)
            .flatMap { [weak self] url -> Observable<(response: HTTPURLResponse, data: Data)> in
                guard let url = URL(string: url) else { return Observable.empty() }
                var request = URLRequest(url: url)
                AuthManager.shared.callWithLatestToken { token in
                    //request = URLRequest(url: url)
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
    
    private func createRequest(url: URL?, method: HTTPMethod, completion: @escaping(URLRequest) -> ()) {
        // We need to check the token is the latest one everytime we make an APICall
        AuthManager.shared.callWithLatestToken { token in
            guard let url = url else { return }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = method.rawValue
            request.timeoutInterval = 45
            completion(request)
        }
    }
}
