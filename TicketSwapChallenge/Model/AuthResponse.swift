//
//  AuthResponse.swift
//  TicketSwapChallenge
//
//  Created by Fernando Ives on 21/07/22.
//

import Foundation

struct AuthResponse: Codable {

    let accessToken: String
    let expiration: Int
    let refreshToken: String?
    let scope: String
    let tokenType: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiration = "expires_in"
        case refreshToken = "refresh_token"
        case scope = "scope"
        case tokenType = "token_type"
    }
    
} 
