//
//  GenericAPIHandler.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import Foundation
import CoreData

public enum Endpoints {
    private var baseUrl: String { return Config.pokemonUrl }
    
    case getPokemonUrls
    case getPokemonData(pokemonName: String)
    
    var method: String {
        switch self {
        case .getPokemonUrls, .getPokemonData:
            return "GET"
        }
    }
    
    var urlPath: String {
        switch self {
        case .getPokemonUrls:
            return baseUrl + "pokemon?limit=151&offset=0"
        case .getPokemonData(let pokemonName):
            return baseUrl + "pokemon/\(String(pokemonName))"
        }
    }
    
    var url: URL? {
        return URL(string: urlPath)
    }
    
    var additionalProperties: [CodingUserInfoKey: Any] {
        switch self {
        case .getPokemonUrls,
                .getPokemonData:
            return [:]
        }
    }
}

public class GenericAPIHandler {
    public static let instance = GenericAPIHandler()
    
    public func request<T: Codable>(endpoint: Endpoints) async -> Result<T, APIError> {
        guard let url = endpoint.url else {
            return Result.failure(.internalError)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        // if too much time passed, timeout
        request.timeoutInterval = 60
        
        return await call(with: request, additionalProperties: endpoint.additionalProperties)
    }
    
    private func call<T: Codable>(with request: URLRequest, additionalProperties: [CodingUserInfoKey: Any]) async -> Result<T, APIError> {
        
        /// Holds the URL string for logs.
        let urlString = request.url?.path ?? ""
        print("Attempting call \(urlString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Response unavailable for url: \(urlString)")
                return Result.failure(.serverError)
            }
            
            // Send status code log to datadog if it is not a 200
            print("Status code for request \(urlString): \(httpResponse.statusCode).")
            
            do {
                guard httpResponse.statusCode != 404 else {
                    print("Status code 404, not attempting to decode response since response is empty.")
                    return Result.failure(.notFound)
                }
                
                // Pass on a background NSManagedObjectContext because with the decoder because this runs on a background thread
                // and the correct context is needed to save Core Data objects.
                // Set up the decoder with the necessary contextual information, such as the merge policy and additional properties, to ensure that the JSON data is decoded correctly and inserted into the appropriate Core Data context.
                let decoder = JSONDecoder()
                let context = PersistenceController.shared.getBackgroundContext()
                decoder.userInfo[.privateContextKey] = context
                additionalProperties.keys.forEach {
                    decoder.userInfo[$0] = additionalProperties[$0]
                }
                
                let dataObject = try decoder.decode(T.self, from: data)
                
                // Save context when decoding finishes to save changes.
                context.saveAndThrow()
                
                return Result.success(dataObject)
            } catch {
                print("Parsing error for request \(urlString): Data corrupted")
                return Result.failure(.parsingError)
            }
            
        } catch let error as NSError {
            print("API Error occurred. Error: \(error.debugDescription)")
            return Result.failure(.serverError)
        }
    }
}
