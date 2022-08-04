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

final class NertworkManager {
    static let shared = NertworkManager()
    
    private func createRequest(url: URL?, method: HTTPMethod, completion: @escaping(URLRequest) -> ()) {
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
