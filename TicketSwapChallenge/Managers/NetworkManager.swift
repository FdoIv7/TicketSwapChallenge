//
//  NetworkManager.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import Foundation

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
                    print("artist name = \(artist.name )")
                    completion(.success(artist))
                } catch {
                    completion(.failure(error ))
                }
            }
            task.resume()
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
