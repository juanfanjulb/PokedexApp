//
//  PokemonResponse.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import Foundation

public struct PokemonResponse: Codable {
    let id: Int
    let name: String
    //let types: [PokemonType]
    let types: [String]
    //let sprites: PokemonSprite
    let sprite: String
    //let stats: [PokemonStat]
    let hp: Int
    let attack: Int
    let defense: Int
    
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            enum TypeKeys:String, CodingKey {
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
        }
    }
}

public struct PokemonType: Codable {
    let type: Type
}

public struct PokemonSprite: Codable {
    let image: String
    
    enum CodingKeys: String, CodingKey {
      case image = "front_default"
    }
}

public struct PokemonStat: Codable {
    let name: Stat
    let value: Int16
    
    enum CodingKeys: String, CodingKey {
        case name = "stat"
        case value = "base_stat"
    }
}

public struct Type: Codable {
    let name: String
}

public struct Stat: Codable {
    let name: String
}
