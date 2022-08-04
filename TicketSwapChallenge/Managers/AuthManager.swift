//
//  AuthManager.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 18/07/22.
//

import Foundation
import RxSwift
import RxCocoa

final class AuthManager {
    
    static let shared = AuthManager()
    private var isRefreshing = false
    private var onRefreshBlocks = [((String) -> ())]()
    
    public var signInURL: URL? {
        let string = "\(Constants.Network.authorizeURL)?response_type=code&client_id=\(Constants.Network.spotifyClientId)&scope=\(Constants.Network.scopes)&redirect_uri=\(Constants.Network.redirectUri)&show_dialog=TRUE"
        return URL(string: string )
    }
    
    var isSigned: Bool {
        // If there's an access token, the user is SignedIn
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        // Refresh token after a couple minutes
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMins: TimeInterval = 1000
        return currentDate.addingTimeInterval(fiveMins) >= expirationDate
    }
    
    public func getCodeForToken(code: String, completion: @escaping((Bool) -> ())) {
        // Get Token
        guard let url = URL(string: Constants.Network.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.Network.redirectUri)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.Network.spotifyClientId + ":" + Constants.Network.spotifyClientSecretKey
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            print("Failure to get base64")
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            // We got data
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(with: result)
                completion(true)
                // API Token needs to be encoded with multipart form APIData - Not in JSON
            } catch {
                print("error = \(error)")
            }
            
        }.resume()
    }
    
    private func cacheToken(with result: AuthResponse) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "access_token")
        if let refreshToken = refreshToken {
            UserDefaults.standard.setValue(refreshToken , forKey: "refresh_token")
        }
        // Current time the user logged in + the number of seconds it expires in
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiration)), forKey: "expirationDate")
         
    }

    // Gives us a Valid Token to make API Calls
    /// REFACTOR THIS!
    public func callWithLatestToken(completion: @escaping(String) -> ()) {
        guard !isRefreshing else {
            // If its refreshing we'll append the completion block
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            // Refresh token
            refreshAccessToken { [weak self] success in
                if success,   let token = self?.accessToken {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            // No need to refresh token
            completion(token)
        }
        return
    }

    // Refresh accessToken if expired
    public func refreshAccessToken(completion: ((Bool) -> ())?) {
        // Check if we are not refreshing so we dont do it twice
        // Made completion optional to be able to pass nil
        guard !isRefreshing else { return  }
        guard shouldRefreshToken else {
            completion?(true)
            return
        }

        guard let refreshToken = refreshToken, let url = URL(string: Constants.Network.tokenAPIURL) else { return }
        isRefreshing = true

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8 )

        let basicToken = Constants.Network.spotifyClientId + ":" + Constants.Network.spotifyClientSecretKey
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion?(false)
            print("Failure to get base  64")
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // We are done refreshing token
            self?.isRefreshing = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            // We got data
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                // We got the token
//                self?.onRefreshBlocks.forEach({ completion in
//                    // We are executing each closure on the closure array passing the latest token
//                    completion(result.accessToken)
//                })
                self?.onRefreshBlocks.forEach({ $0(result.accessToken)} )
                self?.onRefreshBlocks.removeAll() // Remove all closures in the array
                self?.cacheToken(with: result)
                completion?(true)
            } catch {
                print(error)
            }
        }.resume()
    }
}
