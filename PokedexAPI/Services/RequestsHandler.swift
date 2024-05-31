//
//  RequestsHandler.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import Foundation

public class RequestsHandler {
    func getPokemonUrls() async -> Result<InitialPokemonResponse, APIError> {
        return await GenericAPIHandler.instance.request(endpoint: .getPokemonUrls)
    }
    
    func getPokemonData(pokemonName: String) async -> Result<Pokemon, APIError> {
        return await GenericAPIHandler.instance.request(endpoint: .getPokemonData(pokemonName: pokemonName))
    }
}
