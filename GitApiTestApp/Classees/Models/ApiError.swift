//
//  ApiError.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation

struct ServerError: Decodable {
    let message: String
    let documentationUrl: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case documentationUrl = "documentation_url"
    }
}


enum ApiError: Error, LocalizedError {
    case custom(String)
    case defaultError
    case unauthorized
    case sessionExpired
    case notFound
    case noResponse
    case connectionLost
    case internalServerError
    
    
    init(error: Error?, statusCode: Int? = nil) {
        guard let code = statusCode, code >= 0 else {
            if let err = error {
                self = .custom(err.localizedDescription)
            } else {
                self = .defaultError
            }
            return
        }
        switch code {
        case 401:  self = .unauthorized
        case 403: self = .sessionExpired
        case 404: self = .notFound
        case 500: self = .internalServerError
        default: self = .defaultError
        }
    }
    
    init(serverError: ServerError, statusCode: Int? = nil) {
        guard let code = statusCode else {
            self = .custom(serverError.message)
            return
        }
        switch code {
        case 401:  self = .unauthorized
        case 403: self = .sessionExpired
        case 404: self = .notFound
        case 500: self = .internalServerError
        default: self = .defaultError
        }
    }
    
    var title: String {
        switch self {
        case .unauthorized:
            return "Bad credentials"
        default:
            return "Error"
        }
        
        // can be customized according to rerquirements
    }
    
    var message: String {
        switch self {
        case .custom(let message):
            return message
        case .defaultError:
            return "Something went wrong. Try again later"
        case .unauthorized:
            return "Authenticating with invalid credentials. Try Again"
        case .sessionExpired:
            return "Your session is expired. Input login-password to continue"
        case .notFound:
            return "It seems resource is not found... "
        case .noResponse:
            return "The server is not responding"
        case .connectionLost:
            return "Network connection lost. Check you connection and try again"
        case .internalServerError:
            return "server is currently anavailable. Please, try again later"
        }
    }
    
}
