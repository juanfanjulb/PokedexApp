//
//  ImageForType.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 06/06/2024.
//

import Foundation
import SwiftUI

struct ImageForType {
    
    func getImageForType(pokemonTypes: [String], height: CGFloat) -> some View {
        
       let backgroundTypes = pokemonTypes.map { type in
            switch type {
            case "water":
                return "waterType"
            case "grass":
                return "grassType"
            case "fire":
                return "fireType"
            case "psychic":
                return "psychicType"
            case "bug":
                return "bugType"
            case "dark":
                return "darkType"
            case "fairy":
                return "fairyType"
            case "dragon":
                return "dragonType"
            case "electric":
                return "electricType"
            case "fighting":
                return "fightingType"
            case "ghost":
                return "ghostType"
            case "ground":
                return "groundType"
            case "ice":
                return "iceType"
            case "flying":
                return "flyingType"
            case "normal":
                return "normalType"
            case "poison":
                return "poisonType"
            case "rock":
                return "rockType"
            case "steel":
                return "steelType"
            default:
                return ""
            }}
        
        return HStack(spacing: 0) {
            ForEach(backgroundTypes.indices, id: \.self) { index in
                Image(backgroundTypes[index])
                    .frame(height: height)
                    .clipped()
            }
        }
    }
}
