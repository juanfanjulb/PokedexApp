//
//  ContentView.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel: PokemonViewModel
    
    init() {
        // Initialize Core Data on app launch.
        //PersistenceController.shared.loadStore()
        
        viewModel = PokemonViewModel()
    }

    var body: some View {
        ZStack {
            VStack {
                if !viewModel.pokemonData.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.pokemonData.indices, id: \.self) { index in
                                let pokemon = viewModel.pokemonData[index]
                                
                                PokemonCell(id: Int(pokemon.id), name: pokemon.name ?? "", types: pokemon.types ?? [], hp: Int(pokemon.hp), attack: Int(pokemon.attack), defense: Int(pokemon.defense), sprite: pokemon.sprite ?? "", favourite: pokemon.favourite, height: 50)
                                
                                Divider()
                                    .frame(height: 1)
                                    .foregroundStyle(.white)
                                    //.padding(.vertical, 10)
                            }
                        }
                    }
                    .border(Color.blue, width: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 30)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 10)
                    
                } else if viewModel.pokemonDataStatus == .loading {
                    ProgressView("Loading Pokémon...")
                }
                
                Button(action: {
                    Task {
                        await viewModel.getInitialPokemonData()
                    }
                }, label: {
                    Text("Button")
                })
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
