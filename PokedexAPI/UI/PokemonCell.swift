//
//  PokemonCell.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 03/06/2024.
//

import SwiftUI

struct PokemonCell: View {
    
    let id: Int
    let name: String
    let types: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let sprite: String
    @State var favourite: Bool
    let height: CGFloat? = 40
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: sprite))
                        .frame(width: height, height: height)
                        .scaledToFit()
                    
                    Text(name)
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Text("Id: " + String(id))
                    
                    Button(action: {},
                           label: {
                        Image(systemName: favourite ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                            .font(.system(size: 24))
                    })
                    .frame(width: 50, height: 50)
                    
                    
                }
                .padding(.horizontal, 16)
            }
            .frame(height: height)
        }
    }
}

#Preview {
    PokemonCell(id: 11,
                name: "Ditto",
                types: [],
                hp: 49,
                attack: 49,
                defense: 49,
                sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/9.png",
                favourite: false)
}
