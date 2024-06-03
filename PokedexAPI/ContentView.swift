//
//  ContentView.swift
//  PokedexAPI
//
//  Created by Juan Fanjul Bravo on 27/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
//        animation: .default)
//    private var pokemon: FetchedResults<Pokemon>
    @ObservedObject var viewModel: PokemonViewModel
    
    init() {
        // Initialize Core Data on app launch.
        PersistenceController.shared.loadStore()
        
        viewModel = PokemonViewModel()
    }

    var body: some View {
        ZStack {
            VStack {
                if !viewModel.pokemonData.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.pokemonData.indices, id: \.self) { index in
                                let pokemon = viewModel.pokemonData[index]
                                
                                PokemonCell(id: Int(pokemon.id), name: pokemon.name ?? "", types: pokemon.types ?? [], hp: Int(pokemon.hp), attack: Int(pokemon.attack), defense: Int(pokemon.defense), sprite: pokemon.sprite ?? "", favourite: pokemon.favourite)
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                } else if viewModel.pokemonDataStatus == .loading {
                    ProgressView("Loading Pokémon...")
                }
                
                Button(action: {
                    Task {
                        await viewModel.getInitialPokemonData()
                    }
                    //viewModel
                }, label: {
                    Text("Button")
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
