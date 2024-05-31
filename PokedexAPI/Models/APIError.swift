//
//  APIError.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import Foundation

public enum APIError: Error {
    case internalError
    case serverError
    /// Data is not being properly parsed from the json
    case parsingError
    /// Used to react to 404.
    case notFound
    
}
