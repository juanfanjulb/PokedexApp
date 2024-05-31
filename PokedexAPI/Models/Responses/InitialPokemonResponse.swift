//
//  InitialPokemonResponse.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import Foundation

public struct InitialPokemonResponse: Codable {
    let results: [SinglePokemonResult]
}

public struct SinglePokemonResult: Codable {
    let name: String
    let url: String
}
