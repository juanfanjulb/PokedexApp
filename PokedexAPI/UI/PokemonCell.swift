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
    let height: CGFloat
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: sprite))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: height, height: height)
                        //.padding(.vertical, attack > 60 ? 8 : 0)
                       
                    
                    Text(name)
                        .padding(.leading, 5)
                    
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
                .padding(.horizontal, attack > 70 ? 30 : 16)
            }
            
            .background(
                Rectangle()
                    .foregroundStyle(.clear)
                    .overlay {
                        ImageForType().getImageForType(pokemonTypes: types, height:attack < 60 ? height : CGFloat(attack))
                            .opacity(0.8)
                    }
            )
        }
        .frame(height: attack < 60 ? height : CGFloat(attack))
    }
}

#Preview {
    PokemonCell(id: 11,
                name: "Ditto",
                types: ["water", "ice"],
                hp: 49,
                attack: 80,
                defense: 49,
                sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png",
                favourite: false , height: 60)
}
